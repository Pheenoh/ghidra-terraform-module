# Local variables
locals {
  ghidra_version_date            = var.ghidra_version_map[var.ghidra_version]
  ghidra_base_file               = join("", ["ghidra_", var.ghidra_version, "_PUBLIC"])
  ghidra_base_file_w_date_string = join("", [local.ghidra_base_file, "_", local.ghidra_version_date])
  ghidra_file_name               = join("", [local.ghidra_base_file_w_date_string, ".zip"])
  download_uri                   = join("", [var.ghidra_uri, var.ghidra_version, "_build/", local.ghidra_file_name])
  ghidra_instance_name           = join("-", [var.ghidra_name, var.ghidra_version])
  s3_bucket_name                 = var.s3_backup ? join("-", ["ghidra-backups", data.aws_caller_identity.current.account_id]) : null

  server_conf = var.ghidra_server_config != null ? var.ghidra_server_config : templatefile("${path.module}/files/server.conf", {
    java_init_memory   = var.initial_java_heap_size,
    java_max_memory    = var.max_java_heap_size,
    repo_dir           = var.ghidra_repo_path,
    log_file_log_level = var.ghidra_server_log_level,
    ghidra_public_ip   = aws_eip.default.public_ip
  })
}