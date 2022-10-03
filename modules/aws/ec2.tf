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

# Seperate EBS Volume for the repo
resource "aws_ebs_volume" "default" {
  availability_zone = var.create_networking ? aws_subnet.default[0].availability_zone : data.aws_subnet.default[0].availability_zone
  size              = var.repo_volume_size
  type              = var.repo_volume_type
}

# Bind EBS volume to instance as device
resource "aws_volume_attachment" "default" {
  device_name = var.repo_device_name
  volume_id   = aws_ebs_volume.default.id
  instance_id = aws_instance.default.id
}

# EC2 Instance
resource "aws_instance" "default" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  subnet_id              = var.create_networking ? aws_subnet.default[0].id : data.aws_subnet.default[0].id
  iam_instance_profile   = aws_iam_instance_profile.default.id
  vpc_security_group_ids = [aws_security_group.default.id]

  user_data = base64encode(templatefile("${path.module}/../../files/linux_bootstrap.sh",
    {
      GHIDRA_URI        = local.download_uri
      INSTALL_PATH      = var.ghidra_install_path
      SERVER_CONF       = local.server_conf
      GHIDRA_BASE_FILE  = local.ghidra_base_file
      GHIDRA_FILE_NAME  = local.ghidra_file_name
      REPO_PATH         = var.ghidra_repo_path
      BLOCK_DEV_NAME    = var.repo_device_name
      JAVA_DOWNLOAD_URI = var.java_download_uri
      PLATFORM          = "aws"
    }
  ))
  user_data_replace_on_change = true

  tags = {
    Name = local.ghidra_instance_name
  }
}