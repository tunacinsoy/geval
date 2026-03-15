terraform {
  required_version = ">= 1.7, < 2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40, < 6.0"
    }
  }

  # Backend configuration defined in backend.tf
  # Initialize backend with: terraform init -backend-config="bucket=..." -backend-config="key=..." -backend-config="dynamodb_table=..."
}
