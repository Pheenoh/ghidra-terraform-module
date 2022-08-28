# Local variables
locals {
  ghidra_version_date  = var.ghidra_version_map[var.ghidra_version]
  ghidra_base_file     = join("", [var.ghidra_version, "_PUBLIC_", local.ghidra_version_date])
  ghidra_file_name     = join("", [local.ghidra_base_file, ".zip"])
  download_uri         = join("", [var.ghidra_uri, local.ghidra_file_name])
  ghidra_instance_name = join("-", [var.ghidra_name, var.ghidra_version])
  s3_bucket_name       = var.s3_backup ? join("-", ["ghidra-backups", data.aws_caller_identity.current.account_id]) : null
  server_conf          = var.ghidra_server_config != null ? var.ghidra_server_config : "default"
}

# Grab AWS account info
data "aws_caller_identity" "current" {}

# Amazon linux 2 OS image for the instance profile
data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# Lookup VPC ID (if needed)
data "aws_vpc" "default" {
  count = var.create_networking ? 0 : 1
  id    = var.vpc_id
}

# Lookup subnet ID (if needed)
data "aws_subnet" "default" {
  count = var.create_networking ? 0 : 1
  id    = var.subnet_id
}

# IAM role for the instance profile
# Need to split this out into an EC2 and spotfleet IAM role in the future
resource "aws_iam_role" "default" {
  name = "${local.ghidra_instance_name}-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "spotfleet.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

}

# IAM instance profile for launch template
resource "aws_iam_instance_profile" "default" {
  name = "${local.ghidra_instance_name}-instance-profile"
  role = aws_iam_role.default.name
}

# Launch template for the spot fleet or instance
resource "aws_launch_template" "default" {
  name          = "${local.ghidra_instance_name}-launch-template"
  instance_type = "t2.micro"
  key_name      = "test"
  ebs_optimized = true
  image_id      = data.aws_ami.amazon-linux-2.id
  user_data = templatefile("${path.module}/files/aws_bootstrap.sh",
    {
      GHIDRA_URI       = local.download_uri,
      INSTALL_PATH     = var.ghidra_install_path,
      REPO_PATH        = var.ghidra_repo_path,
      SERVER_CONF      = local.server_conf,
      GHIDRA_BASE_FILE = local.ghidra_base_file,
      GHIDRA_FILE_NAME = local.ghidra_file_name,
      INIT_JAVA_HEAP   = var.initial_java_heap_size,
      MAX_JAVA_HEAP    = var.max_java_heap_size,
      LOG_LEVEL        = var.ghidra_server_log_level
    }
  )
  instance_initiated_shutdown_behavior = "stop"

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.default.name
  }

  instance_market_options {
    market_type = "spot"
  }

  network_interfaces {
    associate_public_ip_address = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = local.ghidra_instance_name
    }
  }
}

# Spot fleet
resource "aws_spot_fleet_request" "default" {
  count                           = var.use_spot ? 1 : 0
  iam_fleet_role                  = aws_iam_role.default.arn
  instance_interruption_behaviour = "stop"
  target_capacity                 = 1

  dynamic "launch_specification" {
    for_each = var.spot_instance_types

    content {
      instance_type            = launch_specification.value
      ami                      = data.aws_ami.amazon-linux-2.id
      iam_instance_profile_arn = aws_iam_instance_profile.default.arn

      tags = {
        Name = local.ghidra_instance_name
      }
    }
  }
}

# Bucket for backup
resource "aws_s3_bucket" "default" {
  count  = var.s3_backup ? 1 : 0
  bucket = local.s3_bucket_name
}

# VPC for networking
resource "aws_vpc" "default" {
  count      = var.create_networking ? 1 : 0
  cidr_block = var.cidr_block

  tags = {
    Name = "ghidra-vpc"
  }
}

# Subnet for networking
resource "aws_subnet" "default" {
  count      = var.create_networking ? 1 : 0
  vpc_id     = aws_vpc.default[0].id
  cidr_block = var.cidr_block

  tags = {
    Name = "ghidra-subnet"
  }
}