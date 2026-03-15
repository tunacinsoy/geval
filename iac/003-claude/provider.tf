provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment    = local.environment
      Project        = local.project_name
      CreatedDate    = local.creation_date
      ExpirationDate = local.expiration_date
      Terraform      = true
      ManagedBy      = "Terraform"
    }
  }
}
