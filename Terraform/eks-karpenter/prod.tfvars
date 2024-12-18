vpc_cidr = "198.168.0.0/16"
env = "prod"
subnet_prefix = "2"
clustername = "focus"
aws_region = "us-west-2"  #add region matches to backend bucket region
bootstrapaddon = true
node-group-name = "focus-node-group"
capacity-type= "ON_DEMAND"
disk-size = 20
instance-type = ["t3.medium"]
eks-version = "1.29"
key_name = "focus"