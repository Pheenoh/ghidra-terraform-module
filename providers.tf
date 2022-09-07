# Set provider requirements
terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.29.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = "~> 1.2"
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# Configure the Linode Provider
provider "linode" {
  token = var.linode_token
}