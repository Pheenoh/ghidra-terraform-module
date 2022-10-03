# Global
platform   = "aws"
aws_region = "us-east-2"

# Networking
aws_create_networking = true

# DNS
aws_create_dns_record = true
aws_dns_zone_name     = "tpgz.io"
aws_dns_record_name   = "ghidra-test"

# Ghidra variables
ghidra_version = "10.0"

# S3
aws_s3_backup      = true
aws_s3_bucket_name = "MySuperCoolBucket1234" # Optional