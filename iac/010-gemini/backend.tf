terraform {
  backend "s3" {
    bucket         = "careplus-terraform-state-prod"
    key            = "ami-pipeline/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}