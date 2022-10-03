# Linode variables
variable "region" {
  type        = string
  description = "The Linode region where this infrastructure will be deployed to."
  default     = "us-east"
}

# Ghidra variables
variable "ghidra_name" {
  type        = string
  description = "The name that will be given to the Ghidra instance(s) as a prefix 'ghidra_name-version"
  default     = "ghidra"
}

variable "ghidra_version" {
  type        = string
  description = "The version of Ghidra to install."
  default     = "10.0"
}

# Probably better to do this with a http data source instead
variable "ghidra_version_map" {
  type        = map(any)
  description = "Map of ghidra versions to release dates to properly look up the release URI. You probably won't need to change this unless a new version of Ghidra comes out."
  default = {
    "10.0"   = "20210621",
    "10.0.1" = "20210708",
    "10.0.2" = "20210804",
    "10.0.3" = "20210908",
    "10.0.4" = "20210928",
    "10.1"   = "20211210",
    "10.1.1" = "20211221",
    "10.1.2" = "20220125",
    "10.1.3" = "20220421",
    "10.1.4" = "20220519",
    "10.1.5" = "20220726"
  }
}

variable "ghidra_uri_override" {
  type        = string
  description = "Use this to manually specify the download location of a compressed Ghidra archive. Only set this if you need to use a custom version of Ghidra."
  default     = null
}

variable "ghidra_uri" {
  type        = string
  description = "The URI that will be used along with the ghidra_version as a source endpoint for the Ghidra install files. You probably won't need to change this."
  default     = "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_"
}

variable "ghidra_install_path" {
  type        = string
  description = "The filesystem path where the Ghidra server will be installed to. This path should be an absolute path from the filesystem root."
  default     = "/opt/ghidra/"
}

variable "ghidra_repo_path" {
  type        = string
  description = "The filesystem path where any Ghidra repositories will be stored. This path should be an absolute path from the filesystem root. It is recommended to not have this be a subfolder under the Ghidra installation."
  default     = "/mnt/repos/"
}

variable "ghidra_server_config" {
  type        = string
  description = "Config for the server. If you're setting any of the server.conf variables, don't set this."
  default     = null
}

# server.conf variables
variable "initial_java_heap_size" {
  type        = number
  description = "Initial Java Heap Size (in MB). **(server.conf variable)**"
  default     = 396
}

variable "max_java_heap_size" {
  type        = number
  description = "Maximum Java Heap Size (in MB). **(server.conf variable)**"
  default     = 768
}

variable "ghidra_server_log_level" {
  type        = string
  description = "The log level of the Ghidra server. Should be one of: FATAL, ERROR, WARN, STATUS, INFO, DEBUG. **(server.conf variable)**"
  default     = "INFO"

  validation {
    condition     = contains(["FATAL", "ERROR", "WARN", "STATUS", "INFO", "DEBUG"], var.ghidra_server_log_level)
    error_message = "ghidra_server_log_level must be one of: FATAL, ERROR, WARN, STATUS, INFO, DEBUG."
  }
}

# Linode Instance variables
variable "instance_type" {
  type        = string
  description = "The Linode instance type to use."
  default     = "g6-standard-1"
}

variable "root_pass" {
  type        = string
  description = "The root password of the Linode instance."
  sensitive   = true
  default     = "replaceme"
}

variable "repo_volume_size" {
  type        = number
  description = "The size (in GBs) of the instance volume that will house your Ghidra repos."
  default     = 30
}