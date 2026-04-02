terraform {
  # Local backend for development workspace
  # For staging/prod, configure remote S3 backend via backend config during init
  # Example: terraform init -backend-config="bucket=myproject-terraform-state-staging" -backend-config="key=terraform.tfstate" -backend-config="region=us-east-1" -backend-config="dynamodb_table=terraform-lock-staging" -backend-config="encrypt=true"
  backend "local" {
    path = "terraform.tfstate"
  }
}

# This is a placeholder demonstrating how to configure S3 backend
# Uncomment and configure for remote state management:
# terraform {
#   backend "s3" {
#     bucket         = "myproject-terraform-state-staging"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-lock-staging"
#     encrypt        = true
#     # For production, add:
#     # acl                  = "private"
#     # versioning          = true
#   }
# }
