variable "cider" {
  type    = string
  default = "192.168.0.0/24"
}

data "aws_availability_zones" "available" {}

variable "security-web" {
  description = "Security_group_web"
  type = map(object({
    description = string
    port        = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    "22" = {
      description = "ssh-access"
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0", ]
    }
    "80" = {
      description = "http-access"
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0", ]
    }
    "3306" = {
      description = "mysql-access"
      port        = 3306
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0", ]
    }
  }
}

variable "security-db" {
  description = "Security_group_dev"
  type = map(object({
    description = string
    port        = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    "database" = {
      description = "mysql-access"
      port        = 3306
      protocol    = "tcp"
      cidr_blocks = ["192.168.0.0/25", ]
    }
    "db" = {
      description = "ssh-access"
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["192.168.0.0/25", ]
    }
  }

}

data "aws_ami" "image" {
  most_recent = true
  filter {
    name   = "name"
    values = ["webserver"]
  }

  owners = ["246655928156"] # Canonical
}

# data "aws_instances" "instance_id" {
#   instance_state_names = ["running"]
# }