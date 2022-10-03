module "aws" {
  count                   = lower(var.platform) == "aws" ? 1 : 0
  source                  = "./modules/aws"
  region                  = var.aws_region
  cidr_block              = var.aws_cidr_block
  create_dns_record       = var.aws_create_dns_record
  create_networking       = var.aws_create_networking
  dns_record_name         = var.aws_dns_record_name
  dns_record_ttl          = var.aws_dns_record_ttl
  dns_zone_name           = var.aws_dns_zone_name
  ghidra_install_path     = var.ghidra_install_path
  ghidra_name             = var.ghidra_name
  ghidra_server_config    = var.ghidra_server_config
  ghidra_server_log_level = var.ghidra_server_log_level
  ghidra_repo_path        = var.ghidra_repo_path
  ghidra_uri_override     = var.ghidra_uri_override
  ghidra_uri              = var.ghidra_uri
  ghidra_version          = var.ghidra_version
  ghidra_version_map      = var.ghidra_version_map
  initial_java_heap_size  = var.initial_java_heap_size
  instance_type           = var.aws_instance_type
  max_java_heap_size      = var.max_java_heap_size
  repo_volume_size        = var.repo_volume_size
  repo_volume_type        = var.aws_volume_type
  s3_backup               = var.aws_s3_backup
  s3_bucket_name          = var.aws_s3_bucket_name
  subnet_id               = var.aws_subnet_id
  vpc_id                  = var.aws_vpc_id
}

module "linode" {
  count               = lower(var.platform) == "linode" ? 1 : 0
  source              = "./modules/linode"
  region              = var.linode_region
  instance_type       = var.linode_instance_type
  ghidra_uri_override = var.ghidra_uri_override
  ghidra_name         = var.ghidra_name
  ghidra_version      = var.ghidra_version
  root_pass           = var.linode_root_password
}