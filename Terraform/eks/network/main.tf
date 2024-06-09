resource "aws_vpc" "xenium-vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_support   = true  
    enable_dns_hostnames = true 
    tags = {
        Name = "xenium-vpc-eks"
        "kubernetes.io/cluster/${var.clustername}" = "shared"
    }
}

resource "aws_subnet" "xenium-subnet-pub" {
    vpc_id = var.aws_vpc
    cidr_block = var.pub_cidr
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[0]
    tags = merge(local.common_tags_pub , local.Name_pub)
    depends_on = [ aws_vpc.xenium-vpc ]
}

resource "aws_subnet" "xenium-subnet-prt" {
    vpc_id = var.aws_vpc
    cidr_block = var.prt_cidr
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.available.names[1]
    tags = merge(local.common_tags_prt , local.Name_prt)
    depends_on = [ aws_vpc.xenium-vpc ]
}

