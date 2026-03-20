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

# Configure primary region for cross-region operations (e.g., VPC peering)
provider "aws" {
  alias  = "primary"
  region = "eu-central-1"

  default_tags {
    tags = local.common_tags
  }
}
