terraform {
  required_version = ">= 1.14, < 1.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.31.0, < 7.0"
    }
  }
}
