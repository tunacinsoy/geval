terraform {
  backend "s3" {
    bucket         = "terraform-state-secondary-{account-id}"
    key            = "secondary/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks-secondary"
    encrypt        = true
  }
}

# Note: Replace {account-id} with your actual AWS account ID before running terraform init
# Example: terraform-state-secondary-123456789012
