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

# Launch template for the instance
resource "aws_launch_template" "default" {
  name          = "${local.ghidra_instance_name}-launch-template"
  instance_type = "t2.micro"
  ebs_optimized = true
  image_id      = data.aws_ami.amazon-linux-2.id
  user_data = base64encode(templatefile("${path.module}/files/aws_bootstrap.sh",
    {
      GHIDRA_URI       = local.download_uri,INSTALL_PATH     = var.ghidra_install_path,SERVER_CONF      = local.server_conf,GHIDRA_BASE_FILE = local.ghidra_base_file,GHIDRA_FILE_NAME = local.ghidra_file_name,
    }
  ))
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

    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type             = "persistent"
    }
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

# EC2 Instance
resource "aws_instance" "default" {
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = var.instance_type
  subnet_id                   = var.create_networking ? aws_subnet.default[0].id : data.aws_subnet.default[0].id
  security_groups             = [aws_security_group.default.id]
  iam_instance_profile        = aws_iam_instance_profile.default.id

  launch_template {
    id = aws_launch_template.default.id
  }

  tags = {
    Name = local.ghidra_instance_name
  }
}