# Terraform State Backend Configuration
#
# CURRENT: Local state (terraform.tfstate) for initial development
#
# MIGRATION PATH (Phase 2):
# For production and team collaboration, migrate to AWS S3 + DynamoDB:
#
# 1. Create S3 bucket and DynamoDB table:
#    aws s3api create-bucket --bucket blog-cdn-terraform-state-prod --region us-east-1
#    aws dynamodb create-table \
#      --table-name terraform-locks \
#      --attribute-definitions AttributeName=LockID,AttributeType=S \
#      --key-schema AttributeName=LockID,KeyType=HASH \
#      --billing-mode PAY_PER_REQUEST \
#      --region us-east-1
#
# 2. Enable versioning on S3 bucket:
#    aws s3api put-bucket-versioning \
#      --bucket blog-cdn-terraform-state-prod \
#      --versioning-configuration Status=Enabled
#
# 3. Enable server-side encryption:
#    aws s3api put-bucket-encryption \
#      --bucket blog-cdn-terraform-state-prod \
#      --server-side-encryption-configuration '{
#        "Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]
#      }'
#
# 4. Add backend configuration below (uncomment and replace with your bucket):
#
# terraform {
#   backend "s3" {
#     bucket           = "blog-cdn-terraform-state-prod"
#     key              = "terraform.tfstate"
#     region           = "us-east-1"
#     encrypt          = true
#     dynamodb_table   = "terraform-locks"
#   }
# }
#
# 5. Run terraform init to migrate state:
#    terraform init
#    # When prompted: yes (to confirm state migration)

# For now, use local state
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
