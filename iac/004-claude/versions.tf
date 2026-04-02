terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0, < 7.0"
    }

    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = ">= 1.20.0"
    }
  }
}
