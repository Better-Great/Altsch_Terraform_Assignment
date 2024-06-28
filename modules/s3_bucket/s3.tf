resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
  force_destroy = true

  tags = {
    Name        = "Tween-gency Website Bucket"
    Environment = var.environment
  }
}

locals {
  bucket_regional_domain_name = "${aws_s3_bucket.website_bucket.id}.s3.${var.aws_region}.amazonaws.com"
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_versioning" "versioning_config" {
  bucket = aws_s3_bucket.website_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_cors_configuration" "website" {
  bucket = aws_s3_bucket.website_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "index.html"
  source = "${path.module}/website/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "website_files" {
  for_each = fileset("${path.module}/website", "**/*")

  bucket = aws_s3_bucket.website_bucket.bucket
  key    = each.value
  source = "${path.module}/website/${each.value}"
  etag   = filemd5("${path.module}/website/${each.value}")

  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "jpeg" = "image/jpeg",
    "gif"  = "image/gif",
    "svg"  = "image/svg+xml",
    "txt"  = "text/plain",
    "json" = "application/json",
    "woff" = "font/woff",
    "woff2" = "font/woff2",
    "ttf"  = "font/ttf",
    "eot"  = "application/vnd.ms-fontobject",
    "otf"  = "font/otf"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
}
