terraform {
  backend "s3" {
    bucket         = "proj-terraform-state"
    key            = "customer-order-database-platform/terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = "proj-terraform-lock"
    encrypt        = true
  }
}
