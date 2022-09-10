# Bucket for backup
resource "aws_s3_bucket" "default" {
  count  = var.s3_backup ? 1 : 0
  bucket = local.s3_bucket_name
}