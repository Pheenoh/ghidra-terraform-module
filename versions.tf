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