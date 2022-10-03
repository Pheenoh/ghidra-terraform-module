resource "linode_stackscript" "default" {
  label       = "${local.ghidra_instance_name}-stackscript"
  description = "Installs Ghidra onto a linode instance."
  script = templatefile("${path.module}/../../files/linux_bootstrap.sh",
    {
      GHIDRA_URI       = local.download_uri
      INSTALL_PATH     = var.ghidra_install_path
      SERVER_CONF      = local.server_conf
      GHIDRA_BASE_FILE = local.ghidra_base_file
      GHIDRA_FILE_NAME = local.ghidra_file_name
      REPO_PATH        = var.ghidra_repo_path
      JAVA_DOWNLOAD_URI = var.java_download_uri
      BLOCK_DEV_NAME   = "/dev/sdb" # Hardcoded for Linode
      PLATFORM         = "linode"
    }
  )
  images = ["linode/fedora36"]
}

resource "linode_volume" "default" {
  label  = "${local.ghidra_instance_name}-volume"
  region = var.region
  size   = var.repo_volume_size
}

resource "linode_instance" "default" {
  label  = local.ghidra_instance_name
  region = var.region
  type   = var.instance_type
}

resource "linode_instance_disk" "default" {
  label          = "${local.ghidra_instance_name}-boot_disk"
  linode_id      = linode_instance.default.id
  size           = 25000
  image          = "linode/fedora36"
  root_pass      = var.root_pass
  stackscript_id = linode_stackscript.default.id

  lifecycle {
    replace_triggered_by = [
      linode_stackscript.default.script
    ]
  }
}

resource "linode_instance_config" "boot_config" {
  label       = "${local.ghidra_instance_name}-boot_config"
  linode_id   = linode_instance.default.id
  root_device = "/dev/sda"
  kernel      = "linode/latest-64bit"
  booted      = true

  devices {
    sda {
      disk_id = linode_instance_disk.default.id
    }
    sdb {
      volume_id = linode_volume.default.id
    }
  }

  lifecycle {
    replace_triggered_by = [
      linode_stackscript.default.script
    ]
  }
}