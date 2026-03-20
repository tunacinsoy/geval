terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.30.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

# Configure secondary region for cross-region operations (e.g., S3 replication)
provider "aws" {
  alias  = "secondary"
  region = "eu-west-1"

  default_tags {
    tags = local.common_tags
  }
}
