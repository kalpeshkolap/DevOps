resource "aws_eks_addon" "ebs-csi-driver" {
  cluster_name             = aws_eks_cluster.focus.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.36.0-eksbuild.1"
  service_account_role_arn = aws_iam_role.AmazonEBSCSIDriverRole.arn
  depends_on               = [aws_eks_cluster.focus, aws_eks_node_group.private-nodes]
}

resource "aws_eks_addon" "eks-pod-identity-agent" {
  addon_name   = "eks-pod-identity-agent"
  cluster_name = aws_eks_cluster.focus.name
  addon_version = "v1.3.2-eksbuild.2"
  depends_on               = [aws_eks_cluster.focus, aws_eks_node_group.private-nodes]
}