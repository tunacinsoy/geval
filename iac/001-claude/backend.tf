# Terraform Backend Configuration - S3 + DynamoDB for remote state management
#
# This backend configuration requires pre-created AWS resources:
# 1. S3 bucket for state storage (must exist before terraform init)
# 2. DynamoDB table for state locking (must exist before terraform init)
#
# To initialize with backend:
# aws s3api create-bucket --bucket terraform-state-flower-shop-{account-id} --region us-east-1
# aws dynamodb create-table \
#   --table-name terraform-state-lock \
#   --attribute-definitions AttributeName=LockID,AttributeType=S \
#   --key-schema AttributeName=LockID,KeyType=HASH \
#   --billing-mode PAY_PER_REQUEST
#
# Then init with:
# terraform init -backend-config="bucket=terraform-state-flower-shop-{account-id}" \
#                 -backend-config="key=001-static-website/terraform.tfstate" \
#                 -backend-config="region=us-east-1" \
#                 -backend-config="dynamodb_table=terraform-state-lock" \
#                 -backend-config="encrypt=true"

terraform {
  backend "s3" {
    # NOTE: These values are typically provided via -backend-config flags during terraform init
    # Do NOT hardcode bucket/key values here - use init flags for flexibility
    encrypt                    = true
    skip_requesting_account_id = false
  }
}
