output "ghidra_uri" {
  description = "The Ghidra download URI."
  value       = local.download_uri
}

output "ghidra_public_ip" {
  description = "The private IP of the Ghidra instance."
  value       = linode_instance.default.ip_address
}