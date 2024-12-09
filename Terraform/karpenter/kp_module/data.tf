provider "aws" {
  region = "us-west-2"  # Set your desired AWS region
}
data "aws_eks_cluster_auth" "eks" {
  name = "focus-dev"
}


data "aws_eks_cluster" "eks_cluster" {
  name = "focus-dev"
}

output "endpoint" {
  value = data.aws_eks_cluster.eks_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = data.aws_eks_cluster.eks_cluster.certificate_authority[0].data
}