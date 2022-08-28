# Set provider requirements
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = "~> 1.0"
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}