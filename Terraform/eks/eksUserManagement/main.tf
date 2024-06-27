resource "aws_iam_group" "developers" {
  name = var.group_name
  path = "/"
}


resource "aws_iam_group_policy" "eks_developer_policy" {
  name  = "AmazonEksDeveloperPolicy"
  group = aws_iam_group.developers.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_user_group_membership" "development" {
  for_each = toset(var.aws_iam_user)
  user = each.value

  groups = [
    aws_iam_group.developers.name,
  ]
}