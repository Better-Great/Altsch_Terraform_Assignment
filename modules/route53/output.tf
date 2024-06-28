output "route53_zone_id" {
  description = "The hosted zone ID of the Route 53 zone"
  value       = var.create_dns_record ? aws_route53_zone.main[0].zone_id : null
}

output "website_domain" {
  description = "The domain name of the website"
  value       = var.create_dns_record ? var.domain_name : var.cloudfront_domain_name
}



