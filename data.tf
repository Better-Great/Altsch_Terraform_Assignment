// Fetch information about the current AWS account
data "aws_caller_identity" "current" {}

// Fetch the availability zones in the region
data "aws_availability_zones" "available" {}