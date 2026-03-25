terraform {
  required_version = ">= 1.14.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.31.0, < 7.0"
    }
  }

  backend "s3" {
    bucket         = "resolver-bridge-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "resolver-bridge-state-lock"
    encrypt        = true
  }
}
