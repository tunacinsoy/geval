provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Terraform   = "true"
      Environment = var.environment_tag
      Project     = "flower-shop-website"
      ManagedBy   = "Terraform"
    }
  }
}
