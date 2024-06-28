variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "iam_role_arn" {
  description = "The ARN of the IAM role for API Gateway"
  type        = string
}

variable "environment" {
  description = "The deployment environment"
  type        = string
  default     = "dev"
}
