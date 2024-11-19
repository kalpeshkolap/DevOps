resource "aws_iam_policy" "karpenter-controller-policy" {
  name        = "karpenter-controller-policy"
  path        = "/"
  description = "cluster autoscaler policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowScopedEC2InstanceAccessActions",
            "Effect": "Allow",
            "Resource": [
                "arn:aws:ec2:${var.region}::image/*",
                "arn:aws:ec2:${var.region}::snapshot/*",
                "arn:aws:ec2:${var.region}:*:security-group/*",
                "arn:aws:ec2:${var.region}:*:subnet/*"
            ],
            "Action": [
                "ec2:RunInstances",
                "ec2:CreateFleet"
            ]
        },
        {
            "Sid": "AllowScopedEC2LaunchTemplateAccessActions",
            "Effect": "Allow",
            "Resource": "arn:aws:ec2:${var.region}:*:launch-template/*",
            "Action": [
                "ec2:RunInstances",
                "ec2:CreateFleet"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/kubernetes.io/cluster/${var.clustername}-${var.env}": "owned"
                },
                "StringLike": {
                    "aws:ResourceTag/karpenter.sh/nodepool": "*"
                }
            }
        },
        {
            "Sid": "AllowScopedEC2InstanceActionsWithTags",
            "Effect": "Allow",
            "Resource": [
                "arn:aws:ec2:${var.region}:*:fleet/*",
                "arn:aws:ec2:${var.region}:*:instance/*",
                "arn:aws:ec2:${var.region}:*:volume/*",
                "arn:aws:ec2:${var.region}:*:network-interface/*",
                "arn:aws:ec2:${var.region}:*:launch-template/*",
                "arn:aws:ec2:${var.region}:*:spot-instances-request/*"
            ],
            "Action": [
                "ec2:RunInstances",
                "ec2:CreateFleet",
                "ec2:CreateLaunchTemplate"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:RequestTag/kubernetes.io/cluster/${var.clustername}-${var.env}": "owned",
                    "aws:RequestTag/eks:eks-cluster-name": "${var.clustername}-${var.env}"
                },
                "StringLike": {
                    "aws:RequestTag/karpenter.sh/nodepool": "*"
                }
            }
        },
        {
            "Sid": "AllowScopedResourceCreationTagging",
            "Effect": "Allow",
            "Resource": [
                "arn:aws:ec2:${var.region}:*:fleet/*",
                "arn:aws:ec2:${var.region}:*:instance/*",
                "arn:aws:ec2:${var.region}:*:volume/*",
                "arn:aws:ec2:${var.region}:*:network-interface/*",
                "arn:aws:ec2:${var.region}:*:launch-template/*",
                "arn:aws:ec2:${var.region}:*:spot-instances-request/*"
            ],
            "Action": "ec2:CreateTags",
            "Condition": {
                "StringEquals": {
                    "aws:RequestTag/kubernetes.io/cluster/${var.clustername}-${var.env}": "owned",
                    "aws:RequestTag/eks:eks-cluster-name": "${var.clustername}-${var.env}",
                    "ec2:CreateAction": [
                        "RunInstances",
                        "CreateFleet",
                        "CreateLaunchTemplate"
                    ]
                },
                "StringLike": {
                    "aws:RequestTag/karpenter.sh/nodepool": "*"
                }
            }
        },
        {
            "Sid": "AllowScopedResourceTagging",
            "Effect": "Allow",
            "Resource": "arn:aws:ec2:${var.region}:*:instance/*",
            "Action": "ec2:CreateTags",
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/kubernetes.io/cluster/${var.clustername}-${var.env}": "owned"
                },
                "StringLike": {
                    "aws:ResourceTag/karpenter.sh/nodepool": "*"
                },
                "StringEqualsIfExists": {
                    "aws:RequestTag/eks:eks-cluster-name": "${var.clustername}-${var.env}"
                },
                "ForAllValues:StringEquals": {
                    "aws:TagKeys": [
                        "eks:eks-cluster-name",
                        "karpenter.sh/nodeclaim",
                        "Name"
                    ]
                }
            }
        },
        {
            "Sid": "AllowScopedDeletion",
            "Effect": "Allow",
            "Resource": [
                "arn:aws:ec2:${var.region}:*:instance/*",
                "arn:aws:ec2:${var.region}:*:launch-template/*"
            ],
            "Action": [
                "ec2:TerminateInstances",
                "ec2:DeleteLaunchTemplate"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/kubernetes.io/cluster/${var.clustername}-${var.env}": "owned"
                },
                "StringLike": {
                    "aws:ResourceTag/karpenter.sh/nodepool": "*"
                }
            }
        },
        {
            "Sid": "AllowRegionalReadActions",
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeImages",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceTypeOfferings",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSpotPriceHistory",
                "ec2:DescribeSubnets"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:RequestedRegion": "${var.region}"
                }
            }
        },
        {
            "Sid": "AllowSSMReadActions",
            "Effect": "Allow",
            "Resource": "arn:aws:ssm:${var.region}::parameter/aws/service/*",
            "Action": "ssm:GetParameter"
        },
        {
            "Sid": "AllowPricingReadActions",
            "Effect": "Allow",
            "Resource": "*",
            "Action": "pricing:GetProducts"
        },
        {
            "Sid": "AllowInterruptionQueueActions",
            "Effect": "Allow",
            "Resource": "arn:aws:sqs:${var.region}:860379470066:${var.clustername}-${var.env}",
            "Action": [
                "sqs:DeleteMessage",
                "sqs:GetQueueUrl",
                "sqs:ReceiveMessage"
            ]
        },
        {
            "Sid": "AllowPassingInstanceRole",
            "Effect": "Allow",
            "Resource": "arn:aws:iam::860379470066:role/KarpenterNodeRole-${var.clustername}-${var.env}",
            "Action": "iam:PassRole",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "ec2.amazonaws.com"
                }
            }
        },
        {
            "Sid": "AllowScopedInstanceProfileCreationActions",
            "Effect": "Allow",
            "Resource": "arn:aws:iam::860379470066:instance-profile/*",
            "Action": [
                "iam:CreateInstanceProfile"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:RequestTag/kubernetes.io/cluster/${var.clustername}-${var.env}": "owned",
                    "aws:RequestTag/eks:eks-cluster-name": "${var.clustername}-${var.env}",
                    "aws:RequestTag/topology.kubernetes.io/region": "${var.region}"
                },
                "StringLike": {
                    "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass": "*"
                }
            }
        },
        {
            "Sid": "AllowScopedInstanceProfileTagActions",
            "Effect": "Allow",
            "Resource": "arn:aws:iam::860379470066:instance-profile/*",
            "Action": [
                "iam:TagInstanceProfile"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/kubernetes.io/cluster/${var.clustername}-${var.env}": "owned",
                    "aws:ResourceTag/topology.kubernetes.io/region": "${var.region}",
                    "aws:RequestTag/kubernetes.io/cluster/${var.clustername}-${var.env}": "owned",
                    "aws:RequestTag/eks:eks-cluster-name": "${var.clustername}-${var.env}",
                    "aws:RequestTag/topology.kubernetes.io/region": "${var.region}"
                },
                "StringLike": {
                    "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass": "*",
                    "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass": "*"
                }
            }
        },
        {
            "Sid": "AllowScopedInstanceProfileActions",
            "Effect": "Allow",
            "Resource": "arn:aws:iam::860379470066:instance-profile/*",
            "Action": [
                "iam:AddRoleToInstanceProfile",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:DeleteInstanceProfile"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/kubernetes.io/cluster/${var.clustername}-${var.env}": "owned",
                    "aws:ResourceTag/topology.kubernetes.io/region": "${var.region}"
                },
                "StringLike": {
                    "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass": "*"
                }
            }
        },
        {
            "Sid": "AllowInstanceProfileReadActions",
            "Effect": "Allow",
            "Resource": "arn:aws:iam::860379470066:instance-profile/*",
            "Action": "iam:GetInstanceProfile"
        },
        {
            "Sid": "AllowAPIServerEndpointDiscovery",
            "Effect": "Allow",
            "Resource": "arn:aws:eks:${var.region}:860379470066:cluster/${var.clustername}-${var.env}",
            "Action": "eks:DescribeCluster"
        }
    ]

  })
}

data "aws_iam_policy_document" "Karpenter_Policy-document" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
  depends_on = [aws_iam_policy.karpenter-controller-policy]
}

resource "aws_iam_role" "Karpenter-Role" {
  assume_role_policy = data.aws_iam_policy_document.Karpenter_Policy-document.json
  name               = "karpentercontrollerRole"
  depends_on = [data.aws_iam_policy_document.Karpenter_Policy-document]
}

resource "aws_iam_role_policy_attachment" "Karpenter-controller-Role-attach" {
  policy_arn = aws_iam_policy.karpenter-controller-policy.arn
  role       = aws_iam_role.Karpenter-Role.name
  depends_on = [aws_iam_role.Karpenter-Role]
}

resource "aws_eks_pod_identity_association" "kaapentercontrollerIdentityAssociation" {
  cluster_name    = aws_eks_cluster.focus.name
  namespace       = "kube-system"
  service_account = "karpenter"
  role_arn        = aws_iam_role.Karpenter-Role.arn
  depends_on = [aws_iam_role.Karpenter-Role,aws_eks_cluster.focus]
}

# helm upgrade --install --namespace kube-system --create-namespace \
#   karpenter oci://public.ecr.aws/karpenter/karpenter \
#   --version 1.0.8 \
#   --set "serviceAccount.annotations.eks\.amazonaws\.com/role-arn=arn:aws:iam::860379470066:role/karpentercontrollerRole" \
#   --set settings.clusterName=focus-dev \
#   --set settings.interruptionQueue=focus-dev\
#   --set replicas=1