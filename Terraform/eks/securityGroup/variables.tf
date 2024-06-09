
variable "vpc_cidr" {
    type = list(string)
}

variable "clustername" {}

variable "aws_vpc" {}


variable "inbound-ports" {
    type = list(number)
    default = [ 80, 443]
}


variable "outbound-ports" {
    type = list(number)
    default = [ 443 ]
}
