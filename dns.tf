# DNS Zone Lookup
data "aws_route53_zone" "default" {
  count = var.create_dns_record ? 1 : 0
  name  = var.dns_zone_name
}

# Create DNS record
resource "aws_route53_record" "default" {
  count   = var.create_dns_record ? 1 : 0
  zone_id = data.aws_route53_zone.default[0].id
  name    = var.dns_record_name
  type    = "CNAME"
  ttl     = var.dns_record_ttl
  records = [aws_instance.default.public_dns]
}