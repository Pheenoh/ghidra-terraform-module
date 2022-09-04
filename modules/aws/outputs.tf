output "ghidra_uri" {
  description = "The Ghidra download URI."
  value       = local.download_uri
}

output "ghidra_private_ip" {
  description = "The private IP of the Ghidra instance."
  value       = aws_instance.default.private_ip
}

output "ghidra_public_ip" {
  description = "The private IP of the Ghidra instance."
  value       = aws_instance.default.public_ip
}

output "ghidra_public_dns_name" {
  description = "The public DNS name given to the EC2 instance."
  value       = var.create_dns_record ? aws_route53_record.default[0].fqdn : aws_instance.default.public_dns
}