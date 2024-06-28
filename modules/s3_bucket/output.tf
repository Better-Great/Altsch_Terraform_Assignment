output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.website_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.website_bucket.arn
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.website_bucket.bucket
}

output "bucket_website_endpoint" {
  description = "The endpoint for the S3 bucket website"
  value       = aws_s3_bucket.website_bucket.website_endpoint
}

# output "bucket_regional_domain_name" {
#   description = "The regional domain name of the S3 bucket"
#   value       = local.bucket_regional_domain_name
# }

# output "bucket_regional_domain_name" {
#   value = replace(aws_s3_bucket.website_bucket.bucket_regional_domain_name, "s3-website-", "s3.")
# }

output "bucket_regional_domain_name" {
  description = "The regional domain name of the S3 bucket"
  value       = aws_s3_bucket.website_bucket.bucket_regional_domain_name
}