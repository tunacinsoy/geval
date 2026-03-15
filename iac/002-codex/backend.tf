terraform {
  backend "s3" {
    bucket         = "secure-hr-docs-terraform-state"
    key            = "state/${var.environment}/terraform.tfstate"
    region         = var.region
    dynamodb_table = "secure-hr-docs-locks"
    encrypt        = true
    acl            = "bucket-owner-full-control"
    use_lockfile   = true
  }
}
