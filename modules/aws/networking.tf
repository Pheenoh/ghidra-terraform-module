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

# Security group for Ghidra ingress traffic
resource "aws_security_group" "default" {
  name        = "${local.ghidra_instance_name}-public-sg"
  description = "Allow inbound traffic for the Ghidra server."
  vpc_id      = var.create_networking ? aws_vpc.default[0].id : data.aws_vpc.default[0].id

  ingress {
    description = ""
    from_port   = 13100
    to_port     = 13102
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.ghidra_instance_name}-public-sg"
  }
}

# Define public IP for users to connect to
resource "aws_eip" "default" {
  vpc = true
}

# Associate public IP with Ghidra server
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.default.id
  allocation_id = aws_eip.default.id
}