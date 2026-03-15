terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment         = var.environment
      ManagedBy          = "Terraform"
      DataClassification = "Confidential"
      Department         = "HR"
      Owner              = "Infrastructure"
      Project            = "HR-Document-Storage"
    }
  }
}
