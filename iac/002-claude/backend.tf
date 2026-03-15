terraform {
  backend "s3" {
    bucket           = "org-terraform-state-prod"
    key              = "terraform.tfstate"
    region           = "eu-west-1"
    encrypt          = true
    dynamodb_table   = "terraform-locks-prod"
    acl              = "private"
  }
}
