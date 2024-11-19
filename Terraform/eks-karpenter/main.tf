terraform {
  required_version = ">= 1.0.0" # Ensure that the Terraform version is 1.0.0 or higher

  required_providers {
    aws = {
      source = "hashicorp/aws" # Specify the source of the AWS provider
      version = "~>5.35"        # Use a version of the AWS provider that is compatible with version
    }
  }
  backend "s3" {
    bucket = "kalpesh-9-14-12-19"
    key    = "state/terraform.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  region = var.aws_region # Set the AWS region to US East (N. Virginia)
}

locals {
  prt-subnet = module.network.private-subnet-ids
  pub-subnet = module.network.public-subnet-ids
}

module "network" {
  source = "./networking"
  vpc_cidr = var.vpc_cidr
  env = var.env
  subnet_prefix = var.subnet_prefix
  clustername = var.clustername
}

module "eks" {
  source = "./eks"
  clustername = var.clustername
  private-subnets = local.prt-subnet
  public-subnets = local.pub-subnet
  env = var.env
  bootstrapaddon = var.bootstrapaddon
  node-group-name = var.node-group-name
  capacity-type = var.capacity-type
  disk-size = var.disk-size
  instance-type = [for instance in var.instance-type : instance]
  eks-version = var.eks-version
  depends_on = [module.network.private-subnet-ids, module.network.public-subnet-ids]
  region = var.aws_region
}

