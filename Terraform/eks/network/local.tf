locals {
    common_tags_pub = {
        "kubernetes.io/cluster/${var.clustername}"  =	 "shared"
        "kubernetes.io/role/elb"  =	"1"
    }
    Name_pub = {
        Name = "dev"
    }
}




locals {
    common_tags_prt = {
        "kubernetes.io/cluster/${var.clustername}"  =	 "shared"
        "kubernetes.io/role/internal-elb"  =	"1"
    }
    Name_prt = {
        Name = "dev"
    }
}