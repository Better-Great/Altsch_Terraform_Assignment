terraform {
   required_version = ">= 1.2.0, <= 1.8.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.55.0"  
    }
  }
}

# The Cloud provider Tween-gency is hosting the static website on
provider "aws" {
  region = var.aws_region
}
