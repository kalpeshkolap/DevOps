variable "clustername" {}
variable "env" {}
variable "public-subnets" {}
variable "private-subnets" {}
variable "node-group-name" {}
variable "disk-size" {}
variable "capacity-type" {}
variable "ec2-ssh-key" {}
variable "instance-type" {
  type = list(string)
}
variable "eks-version" {}
variable "bootstrapaddon" {
  type = bool
  default = true
}
variable "region" {}
variable "security_group_id" {
  type = list(string)
}