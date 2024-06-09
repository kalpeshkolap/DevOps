provider "aws" {
  region = "us-west-2"
  profile = "default"
}

terraform {
  backend "s3" {
    bucket         = "xen-tera-bucket"
    key            = "state/terraform.tfstate"
    region         = "us-west-2"
  }
}

locals {
  clustername = "xenium-dev-cluster"
  vpc_cidr = "10.0.0.0/16"
  aws_vpc = module.xenium-network.vpc_id
  xenium-pub-subnet = module.xenium-network.xenium-pub-subnet
  xenium-prt-subnet = module.xenium-network.xenium-prt-subnet
  xenium-security_group = module.security_group.security_group
}

module "xenium-network" {
  source = "./network"
  clustername = local.clustername
  vpc_cidr = local.vpc_cidr
  prt_cidr = "10.0.0.0/24"
  pub_cidr = "10.0.1.0/24"
  aws_vpc = local.aws_vpc 
}

module "xenium-route" {
  source = "./routes"
  xenium-prt-subnet =  local.xenium-prt-subnet
  xenium-pub-subnet =  local.xenium-pub-subnet
  aws_vpc = local.aws_vpc
}

module "security_group" {
  source = "./securityGroup"
  aws_vpc = local.aws_vpc
  vpc_cidr = ["${local.vpc_cidr}"]
  inbound-ports = [ 80 , 443 ]
  outbound-ports = [ 443 ]
  clustername = local.clustername
}


module "eks" {
  source = "./eks"
  clustername = local.clustername
  aws_vpc =  local.aws_vpc
  xenium-pub-subnet = local.xenium-pub-subnet
  xenium-prt-subnet = local.xenium-prt-subnet
  xenium-pub-sg = local.xenium-security_group
}