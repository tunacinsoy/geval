terraform {
  backend "s3" {
    # Configure with environment-specific bucket and state path
    # Example: bucket = "my-project-terraform-state-123456789", key = "001-ami-hardening-pipeline/terraform.tfstate"
    # DynamoDB table must exist: "my-project-terraform-lock"
    # This backend configuration should be provided via -backend-config flags during terraform init
    # OR set via environment variables: TF_BACKEND_BUCKET, TF_BACKEND_KEY, TF_BACKEND_DYNAMODB_TABLE, TF_BACKEND_REGION

    # For local development, comment out S3 backend and uncomment below for local state:
    # path = "terraform.tfstate"

    # Production backend example (set via -backend-config or environment variables):
    # bucket         = "my-project-terraform-state-123456789"
    # key            = "001-ami-hardening-pipeline/terraform.tfstate"
    # region         = "us-east-1"
    # dynamodb_table = "my-project-terraform-lock"
    # encrypt        = true
    # skip_region_validation = false
  }
}

# NOTE: For local development and testing:
# 1. Comment out S3 backend above
# 2. Uncomment local backend below
# 3. Run: terraform init
#
# For production setup with S3 backend:
# 1. Create S3 bucket: aws s3api create-bucket --bucket my-project-terraform-state-123456789 --region us-east-1
# 2. Enable versioning: aws s3api put-bucket-versioning --bucket my-project-terraform-state-123456789 --versioning-configuration Status=Enabled
# 3. Enable encryption: aws s3api put-bucket-encryption --bucket my-project-terraform-state-123456789 --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "aws:kms", "KMSMasterKeyID": "arn:aws:kms:us-east-1:123456789:key/12345678-1234-1234-1234-123456789"}}]}'
# 4. Create DynamoDB table: aws dynamodb create-table --table-name my-project-terraform-lock --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST --region us-east-1
# 5. Run: terraform init -backend-config="bucket=my-project-terraform-state-123456789" -backend-config="key=001-ami-hardening-pipeline/terraform.tfstate" -backend-config="region=us-east-1" -backend-config="dynamodb_table=my-project-terraform-lock" -backend-config="encrypt=true"
