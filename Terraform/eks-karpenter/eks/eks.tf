resource "aws_eks_cluster" "focus" {
  name     = "${var.clustername}-${var.env}"
  role_arn = aws_iam_role.eks.arn
  version  = var.eks-version
  bootstrap_self_managed_addons = var.bootstrapaddon
  vpc_config {
    subnet_ids              = concat(var.private-subnets, var.public-subnets)
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy]
}

data "tls_certificate" "focus-tls" {
  url        = aws_eks_cluster.focus.identity[0].oidc[0].issuer
  depends_on = [aws_eks_cluster.focus]
}

resource "aws_iam_openid_connect_provider" "focus-oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.focus-tls.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.focus.identity[0].oidc[0].issuer
  depends_on      = [data.tls_certificate.focus-tls]
}