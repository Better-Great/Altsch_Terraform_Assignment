variable "environment" {
  description = "The environment for deployment (e.g., dev, prod)"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "bucket_regional_domain_name" {
  description = "The regional domain name of the S3 bucket"
  type        = string
}

variable "bucket_arn" {
  description = "The ARN of the S3 bucket"
  type        = string
}