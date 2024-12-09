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
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_name = module.eks.cluster_name
}

module "network" {
  source = "./networking"
  vpc_cidr = var.vpc_cidr
  env = var.env
  subnet_prefix = var.subnet_prefix
  clustername = var.clustername
  key_name = var.key_name
  private_key_pem = var.private_key_pem
}

module "eks" {
  source = "./eks"
  clustername = "${var.clustername}-${var.env}"
  private-subnets = local.prt-subnet
  public-subnets = local.pub-subnet
  env = var.env
  disk-size = var.disk-size
  bootstrapaddon = var.bootstrapaddon
  node-group-name = var.node-group-name
  capacity-type = var.capacity-type
  instance-type = ["${var.instance-type}"]
  eks-version = var.eks-version
  depends_on = [module.network.private-subnet-ids, module.network.public-subnet-ids,module.security]
  region = var.aws_region
  ec2-ssh-key = module.network.public_key
  security_group_id = ["${module.security.security_group_id}"]
  security_group_name = ["${module.security.security_group_name}"]
  instance_type = var.instance_type
}

module "bashion" {
  source = "./bashion"
  instance_keypair = module.network.public_key
  instance_type = var.instance_type
  security_group_id = module.security.security_group_id
  subnet_id_bashion = ["${element(module.network.public-subnet-ids,0 )}"]
  depends_on = [module.network]
}

module "security" {
  source = "./security"
  vpc_id = module.network.vpc_id
  depends_on = [module.network]
}



