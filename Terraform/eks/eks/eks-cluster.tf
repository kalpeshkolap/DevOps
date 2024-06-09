resource "aws_iam_role" "eks" {
  name = "eks-cluster-role"

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



resource "aws_eks_cluster" "xenium" {
  name     = var.clustername
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids = [
      var.xenium-prt-subnet,
      var.xenium-pub-subnet
    ]
    # endpoint_private_access = true
    # endpoint_public_access = 
    security_group_ids = [
      var.xenium-pub-sg ]
  }

  depends_on = [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
                    ]
}