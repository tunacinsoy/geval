terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket         = "terraform-state-009-hybrid-dns"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock-009-hybrid-dns"
  }
}
