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

# EC2 Instance
resource "aws_instance" "default" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  subnet_id              = var.create_networking ? aws_subnet.default[0].id : data.aws_subnet.default[0].id
  iam_instance_profile   = aws_iam_instance_profile.default.id
  vpc_security_group_ids = [aws_security_group.default.id]

  user_data = base64encode(templatefile("${path.module}/files/aws_bootstrap.sh",
    {
      GHIDRA_URI       = local.download_uri,
      INSTALL_PATH     = var.ghidra_install_path,
      SERVER_CONF      = local.server_conf,
      GHIDRA_BASE_FILE = local.ghidra_base_file,
      GHIDRA_FILE_NAME = local.ghidra_file_name
    }
  ))
  user_data_replace_on_change = true

  tags = {
    Name = local.ghidra_instance_name
  }
}