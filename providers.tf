# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# Configure the Linode Provider
provider "linode" {
  token = var.linode_token
}