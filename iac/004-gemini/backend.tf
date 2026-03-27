terraform {
  backend "s3" {
    bucket         = "customer-database-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "customer-database-tfstate-lock"
    encrypt        = true
  }
}
