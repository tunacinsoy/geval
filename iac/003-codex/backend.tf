terraform {
  backend "s3" {
    bucket         = "playground-terraform-state"
    key            = "001-setup-playground/terraform.tfstate"
    region         = var.region
    dynamodb_table = "playground-terraform-lock"
    encrypt        = true
  }
}
