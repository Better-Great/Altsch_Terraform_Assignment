output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "The CloudFront Distribution hosted zone ID"
  value       = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}
