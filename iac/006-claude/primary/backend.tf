terraform {
  backend "s3" {
    bucket         = "terraform-state-primary-{account-id}"
    key            = "primary/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks-primary"
    encrypt        = true
  }
}

# Note: Replace {account-id} with your actual AWS account ID before running terraform init
# Example: terraform-state-primary-123456789012
