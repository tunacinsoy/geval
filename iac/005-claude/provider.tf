provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = "blog-cdn"
      Environment = var.environment
      ManagedBy   = "terraform"
      CostCenter  = "engineering"
      CreatedDate = "2026-04-02"
    }
  }
}
