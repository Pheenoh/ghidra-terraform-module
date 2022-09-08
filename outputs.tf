output "ghidra_uri" {
  description = "The Ghidra download URI."
  value       = var.platform == "aws" ? module.aws[0].ghidra_uri : module.linode[0].ghidra_uri
}

output "ghidra_private_ip" {
  description = "The private IP of the Ghidra instance."
  value       = var.platform == "aws" ? module.aws[0].ghidra_private_ip : ""
}

output "ghidra_public_ip" {
  description = "The private IP of the Ghidra instance."
  value       = var.platform == "aws" ? module.aws[0].ghidra_public_ip : module.linode[0].ghidra_public_ip
}

output "ghidra_public_dns_name" {
  description = "The public DNS name given to the EC2 instance."
  value       = var.platform == "aws" ? module.aws[0].ghidra_public_dns_name : ""
}