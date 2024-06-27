resource "aws_eks_addon" "eks-pod-identity" {
  cluster_name                = var.clustername
  addon_name                  = "eks-pod-identity-agent"
  addon_version               = "v1.2.0-eksbuild.1" 
  depends_on = [ local.clusterid ]
}

data "aws_iam_policy_document" "s3_assume_role" {
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
}

resource "aws_iam_role" "s3role" {
  name               = "AmazonS3ReadOnlyAccess-s3"
  assume_role_policy = data.aws_iam_policy_document.s3_assume_role.json
}

resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.s3role.name
}
resource "aws_eks_pod_identity_association" "s3" {
  cluster_name    = var.clustername
  namespace       = "default"
  service_account = "default"
  role_arn        = aws_iam_role.s3role.arn
  depends_on = [ aws_iam_role.s3role,
                  local.clusterid  ]
}