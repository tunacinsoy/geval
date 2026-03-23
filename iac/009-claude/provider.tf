provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = "hybrid-dns-resolver"
      ManagedBy   = "Terraform"
      Team        = "infrastructure"
      CostCenter  = var.cost_center
    }
  }
}
