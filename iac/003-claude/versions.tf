terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.36.0, < 7.0"
    }
  }

  cloud {
    organization = "your-org"  # TODO: Replace with your Terraform Cloud organization
    workspaces {
      name = "003-test-playground"
    }
  }
}
