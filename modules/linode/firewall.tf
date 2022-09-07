resource "linode_firewall" "default" {
  label           = "${local.ghidra_instance_name}-firewall"
  linodes         = [linode_instance.default.id]
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  inbound {
    label    = "allow-ghidra"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "13100-13102"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }
}