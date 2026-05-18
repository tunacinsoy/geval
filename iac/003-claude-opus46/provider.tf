terraform {
  required_version = ">= 1.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0, < 7.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.environment
      Expiry      = var.expiry_date
      Owner       = var.owner
      ManagedBy   = "terraform"
      Project     = var.project
    }
  }
}
