terraform {
  backend "s3" {
    bucket         = "flower-shop-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "flower-shop-terraform-locks"
    encrypt        = true
  }
}
