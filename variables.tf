# Global module variables
variable "platform" {
  type        = string
  description = "The provider you're deploying to. Should be one of: aws."
  default     = "aws"

  validation {
    condition     = contains(["aws", "linode"], lower(var.platform))
    error_message = "The provider you supplied is wrong. Should be one of: aws, linode."
  }
}

# AWS module variables
variable "aws_region" {
  type        = string
  description = "The AWS region where this infrastructure will be deployed to."
  default     = "us-east-2"
}

variable "aws_volume_type" {
  type        = string
  description = "The EBS volume type that will house your Ghidra repos."
  default     = "gp2"
}

# S3 variables
variable "aws_s3_backup" {
  type        = bool
  description = "Whether or not to create an S3 backup."
  default     = false
}

variable "aws_s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket that will be used for the Ghidra database backups. Since S3 buckets have to be globally unique, it's recommended not to set this and let the module generate it for you."
  default     = null
}

variable "aws_create_networking" {
  type        = bool
  description = "Whether or not to create the networking infrastructure for the instance. If you already have a preexsting VPC for the instance(s) to go in, set this to false."
  default     = true
}

variable "aws_cidr_block" {
  type        = string
  description = "The CIDR range to use for the private network."
  default     = "10.0.0.0/24"
}

variable "aws_vpc_id" {
  type        = string
  description = "The ID of the VPC to lookup and place the instance(s) in. Do not set this if create_networking is true."
  default     = null
}

variable "aws_subnet_id" {
  type        = string
  description = "The ID of the subnet to lookup and place the instance(s) in. Do no set this if create_networking is true."
  default     = null
}

variable "aws_create_dns_record" {
  type        = bool
  description = "Whether or not to create a dedicated DNS record for the server. If you have a pre-existing Route53 zone in your AWS account, you can set this to true to create a dedicated record on it."
  default     = false
}

variable "aws_dns_zone_name" {
  type        = string
  description = "The DNS zone to lookup in the account to provision the DNS record on."
  default     = "replaceme"
}

variable "aws_dns_record_name" {
  type        = string
  description = "The name of the DNS record to create on the zone looked up by `dns_zone_name`."
  default     = "ghidra"
}

variable "aws_dns_record_ttl" {
  type        = number
  description = "The time-to-live for the DNS record"
  default     = 60
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

variable "ghidra_zip_file_name" {
  description = "tmp variable. don't use."
  default     = null
}

variable "ghidra_extract_folder_name" {
  description = "tmp variable. don't use."
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

variable "java_download_uri" {
  type = string
  description = "URI of the JAVA installer to download."
  default = "https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz"
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

# EC2 variables
variable "aws_instance_type" {
  type        = string
  description = "The EC2 instance type to use."
  default     = "t3.micro"
}



variable "repo_volume_size" {
  type        = number
  description = "The size (in GBs) of the volume that will house your Ghidra repos."
  default     = 30
}

variable "repo_device_name" {
  type        = string
  description = "The name given to the repo volume in Linux."
  default     = "/dev/sdb"
}

# Linode variables
variable "linode_region" {
  type        = string
  description = "The Linode region where this infrastructure will be deployed to."
  default     = "us-east"
}

# Linode Instance variables
variable "linode_instance_type" {
  type        = string
  description = "The Linode instance type to use."
  default     = "g6-standard-1"
}

variable "linode_config_path" {
  type        = string
  description = "Path to your local linode config file."
  default     = "~/.config/linode-cli"
}

variable "linode_root_password" {
  type        = string
  description = "The root password of the Linode instance."
  sensitive   = true
  default     = "replaceme"
}

variable "linode_token" {
  type        = string
  description = "API token to connect to your Linode tenant."
  sensitive   = true
  default     = "replaceme"
}