# Networking Examples

All the examples in the folders assume you want to create the networking stack in AWS (meaning, you don't already have one provisioned in the region you're deploying to).

- [default](./default/terraform.tfvars) - Default deployment. Sets the ghidra version and deploys a DNS record for the server.
- [java_heap](./java_heap/terraform.tfvars) - Same as default, but modifies the Java heap settings in the server.conf file.
- [s3_backup](./s3_backup/terraform.tfvars) - Same as default, but configures an S3 bucket for EBS snapshot backups.