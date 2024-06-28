resource "aws_route53_zone" "main" {
  count = var.create_dns_record ? 1 : 0
  name  = var.domain_name
}

resource "aws_route53_record" "main" {
  count   = var.create_dns_record ? 1 : 0
  zone_id = var.create_dns_record ? aws_route53_zone.main[0].zone_id : ""
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
