resource "aws_iam_user" "development" {
    for_each = toset(var.aws_iam_user)
    name = each.value
    path = "/"
    tags = local.Name_pub
}

resource "aws_eks_access_entry" "example" {
  for_each = data.aws_iam_user.user
  cluster_name      = var.clustername
  principal_arn     = each.value.arn
  kubernetes_groups = ["developer"]
  type              = "STANDARD"
  depends_on = [ aws_iam_group.developers , var.eks_cluster_id  ]
}

data "aws_iam_user" "user" {
  for_each = aws_iam_user.development

  user_name = each.value.name
  depends_on = [ var.eks_cluster_id , var.clustername ]
}
