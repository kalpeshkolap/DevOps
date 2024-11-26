variable "vpc_cidr" {}
variable "env" {}
variable "subnet_prefix" {}
variable "clustername" {}
variable "aws_region" {}
variable "node-group-name" {
  type = string
  default = "ng-node"
}
variable "disk-size" {}
variable "capacity-type" {}
variable "instance-type" {
  type = list(string)
}
variable "eks-version" {}
variable "bootstrapaddon" {
  type    = bool
  default = true
}
variable "key_name" {}
variable "instance_type" {}

variable "private_key_pem" {}