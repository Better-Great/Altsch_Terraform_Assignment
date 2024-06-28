variable "create_dns_record" {
  description = "Whether to create a DNS record in Route 53"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "The domain name for the website"
  type        = string
  default     = ""
}

variable "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  type        = string
}

variable "cloudfront_hosted_zone_id" {
  description = "The CloudFront distribution hosted zone ID"
  type        = string
}