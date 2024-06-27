variable "clustername" {}

variable "aws_iam_user" {
  description = "List of IAM user names"
  type        = list(string)
  default     = ["user1", "user2"]
}

variable "group_name" {
    type = string
}

variable "eks_cluster_id" {}
