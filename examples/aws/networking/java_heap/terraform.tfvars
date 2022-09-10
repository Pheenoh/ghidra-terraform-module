# Global
platform   = "aws"
aws_region = "us-east-2"

# Networking
create_networking = true

# DNS
create_dns_record = true
dns_zone_name     = "tpgz.io"
dns_record_name   = "ghidra-test"

# Ghidra variables
ghidra_version      = "10.0"
init_java_heap_size = 1024
max_java_heap_size  = 2048