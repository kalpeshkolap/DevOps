#storing state file to remote location(aws_s3 backend)
terraform {
  backend "s3" {
    bucket = "YourBucketName"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}