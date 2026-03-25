terraform {
  required_version = ">= 1.14.0, < 1.15.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.30.0, < 7.0.0"
    }
  }
}
