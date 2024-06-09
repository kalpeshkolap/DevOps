resource "aws_eks_addon" "eks-pod-identity" {
  cluster_name                = var.clustername
  addon_name                  = "eks-pod-identity-agent"
  addon_version               = "v1.2.0-eksbuild.1" 
  depends_on = [ local.clusterid ]
}



resource "aws_iam_role" "s3role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Statement = [{
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"]
      Effect = "Allow"
      principals =  {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonS3ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.s3role.name
}

resource "aws_eks_pod_identity_association" "s3" {
  cluster_name    = var.clustername
  namespace       = "default"
  service_account = "default"
  role_arn        = aws_iam_role.s3role.arn
  depends_on = [ aws_iam_role.s3role ]
}