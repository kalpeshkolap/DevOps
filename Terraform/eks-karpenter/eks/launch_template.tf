resource "aws_launch_template" "ubuntu_template" {
  name          = "ubuntu-launch-template"
  image_id      = "ami-0007f7f13a638f245"
  key_name = var.ec2-ssh-key
  # iam_instance_profile {
  #   name = aws_iam_instance_profile.node_instance_profile.name
  # }
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp3"
    }
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }
  tags = {
    "karpenter.sh/discovery" = "${var.clustername}-${var.env}"
     Name                     = "focus-${var.env}-node"
  }
  depends_on = [
    aws_iam_instance_profile.node_instance_profile
  ]
}
