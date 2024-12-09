resource "aws_launch_template" "eks_node_group" {
  name          = "eks-node-group-launch-template"
  image_id      = "ami-056899329d49c452b"
  instance_type = var.instance_type
  key_name      = var.ec2-ssh-key
  vpc_security_group_ids = var.security_group_id
  ebs_optimized = true
  user_data = base64encode(<<EOF
      #!/bin/bash
      sudo  apt-get update -y
      sudo apt-get install -y apt-transport-https ca-certificates curl gpg
      curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
      sudo  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
      sudo apt update
      sudo  apt-get install -y awscli
      sudo  apt-get install -y kubelet kubeadm kubectl
      # Bootstrap the instance into the EKS cluster
      sudo  /etc/eks/bootstrap.sh ${var.clustername}
      EOF
  )
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 20 # Specify the disk size (in GB)
      volume_type           = "gp3" # Specify the volume type (gp3 is recommended)
      delete_on_termination = true # Ensure the volume is deleted when the instance is terminated
    }
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }
  monitoring {
    enabled = false
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "eks-node"
    }
  }
}



