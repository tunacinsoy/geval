provider "aws" {
  region              = var.aws_region
  allowed_account_ids = var.aws_allowed_account_ids
  default_tags {
    tags = var.common_tags
  }
}
