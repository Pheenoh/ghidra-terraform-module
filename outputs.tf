output "ghidra_uri" {
  description = "The Ghidra download URI."
  value       = local.download_uri
}

output "ghidra_private_ip" {
  description = "The private IP of the Ghidra instance."
  value       = aws_launch_template.default.network_interfaces[0].private_ip_address
}


output "ghidra_public_ip" {
  description = "The private IP of the Ghidra instance."
  value       = aws_launch_template.default.network_interfaces[0].ipv4_addresses
}