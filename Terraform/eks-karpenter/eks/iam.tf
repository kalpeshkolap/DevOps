resource "aws_iam_role" "eks" {
  name = "eks-cluster-role-kp"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks.name
}


resource "aws_iam_role" "NodeRole" {
  name = "KarpenterNodeRole-${var.clustername}-${var.env}"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.NodeRole.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.NodeRole.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.NodeRole.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonSSMManagedInstanceCore_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.NodeRole.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.NodeRole.name
}

# creating role for ebs csi driver addon

data "aws_iam_policy_document" "AmazonEBSCSIDriverRole-policy-document" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.focus-oidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.focus-oidc.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "AmazonEBSCSIDriverRole" {
  assume_role_policy = data.aws_iam_policy_document.AmazonEBSCSIDriverRole-policy-document.json
  name               = "AmazonEBSCSIDriverRole"
}

resource "aws_iam_role_policy_attachment" "ebs-csi-controller-attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.AmazonEBSCSIDriverRole.name
}

# creating role for vpc cni addon

data "aws_iam_policy_document" "AmazonEKS_CNI_Policy-document" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.focus-oidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.focus-oidc.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "AmazonEKS_CNIRole" {
  assume_role_policy = data.aws_iam_policy_document.AmazonEBSCSIDriverRole-policy-document.json
  name               = "AmazonEKS_CNIRole"
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNIRole-attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.AmazonEKS_CNIRole.name
}

resource "aws_eks_access_entry" "karpenter-api-access" {
  cluster_name  = "${var.clustername}-${var.env}"
  principal_arn = aws_iam_role.NodeRole.arn
  type          = "EC2_LINUX"
  depends_on = [local.clusterid]
}

