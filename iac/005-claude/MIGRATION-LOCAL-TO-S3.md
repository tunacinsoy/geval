# Migration Guide: Local State to AWS S3 + DynamoDB

This guide explains how to migrate Terraform state from local storage (`terraform.tfstate`) to AWS S3 + DynamoDB for production-grade state management.

## Why Migrate?

**Local state issues**:
- ❌ Not suitable for team collaboration (risk of concurrent modifications)
- ❌ No automatic locking (concurrent `terraform apply` can corrupt state)
- ❌ State file stored locally, risk of loss or accidental deletion
- ❌ No audit trail or version history

**Remote state (S3 + DynamoDB) benefits**:
- ✅ Secure remote storage with encryption
- ✅ Automatic locking with DynamoDB (prevents concurrent modifications)
- ✅ Version history via S3 versioning (rollback capability)
- ✅ Team collaboration with access control
- ✅ Audit trail of all state changes

## Prerequisites

Before migrating, ensure you have:

1. **AWS CLI** installed and configured:
   ```bash
   aws --version
   aws s3 ls  # Test credentials
   ```

2. **IAM Permissions** to create S3 buckets and DynamoDB tables:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Action": [
           "s3:CreateBucket",
           "s3:PutBucketVersioning",
           "s3:PutEncryptionConfiguration",
           "s3:PutBucketPolicy"
         ],
         "Resource": "arn:aws:s3:::blog-cdn-terraform-state-*"
       },
       {
         "Effect": "Allow",
         "Action": [
           "dynamodb:CreateTable",
           "dynamodb:DescribeTable"
         ],
         "Resource": "arn:aws:dynamodb:*:*:table/terraform-locks"
       }
   }
   ```

3. **Terraform** >= 1.6.0 installed

## Step-by-Step Migration

### Step 1: Backup Local State

Create a backup before migrating:

```bash
cd iac/
cp terraform.tfstate terraform.tfstate.backup

# Verify backup exists
ls -la terraform.tfstate*
# Output: terraform.tfstate, terraform.tfstate.backup
```

### Step 2: Create S3 Bucket for State

```bash
# Define bucket name (must be globally unique)
BUCKET_NAME="blog-cdn-terraform-state-prod"
REGION="us-east-1"

# Create S3 bucket
aws s3api create-bucket \
  --bucket $BUCKET_NAME \
  --region $REGION

echo "✓ S3 bucket created: $BUCKET_NAME"
```

### Step 3: Enable S3 Versioning

Enable versioning for rollback capability:

```bash
aws s3api put-bucket-versioning \
  --bucket $BUCKET_NAME \
  --versioning-configuration Status=Enabled

echo "✓ Versioning enabled on S3 bucket"
```

### Step 4: Enable S3 Encryption

Enable server-side encryption to protect state files:

```bash
aws s3api put-bucket-encryption \
  --bucket $BUCKET_NAME \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

echo "✓ Encryption enabled on S3 bucket"
```

### Step 5: Block Public Access to S3 Bucket

Ensure the bucket cannot be accessed publicly:

```bash
aws s3api put-public-access-block \
  --bucket $BUCKET_NAME \
  --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

echo "✓ Public access blocked on S3 bucket"
```

### Step 6: Create DynamoDB Table for Locking

Create a table for Terraform state locking:

```bash
LOCK_TABLE="terraform-locks"

aws dynamodb create-table \
  --table-name $LOCK_TABLE \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region $REGION

echo "✓ DynamoDB table created: $LOCK_TABLE"
```

**Note**: It may take 5-10 seconds for the table to be created. Wait for the table status to be "ACTIVE":

```bash
aws dynamodb describe-table --table-name $LOCK_TABLE --query 'Table.TableStatus'
# Expected output: "ACTIVE"
```

### Step 7: Update Terraform Backend Configuration

Uncomment and update the backend configuration in `iac/backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket           = "blog-cdn-terraform-state-prod"
    key              = "terraform.tfstate"
    region           = "us-east-1"
    encrypt          = true
    dynamodb_table   = "terraform-locks"
  }
}
```

**IMPORTANT**: Replace the local backend block with the S3 backend block.

### Step 8: Initialize Terraform with New Backend

Run `terraform init` to migrate state to S3:

```bash
cd iac/
terraform init
```

Terraform will prompt you:

```
Do you want to copy existing state to the new backend?
```

**Respond**: `yes`

Expected output:
```
Successfully configured the backend "s3"!
Terraform will automatically use this state unless you reconfigure it.
```

### Step 9: Verify Migration

Verify that state was successfully migrated:

```bash
# Check local state file no longer exists
ls terraform.tfstate
# Output: No such file or directory (expected)

# Check state is in S3
aws s3 ls s3://blog-cdn-terraform-state-prod/
# Output: terraform.tfstate

# Verify Terraform can read state
terraform state list
# Output: List of resources (should show CloudFront distribution, S3 bucket, etc.)
```

### Step 10: Cleanup Local Backup

After verifying migration is successful, clean up local backup:

```bash
# Optional: Keep backup for safety, or remove after verification
rm terraform.tfstate.backup
rm terraform.tfstate.backup.* 2>/dev/null

echo "✓ Local state backup removed"
```

## Verification Checklist

After migration, verify:

- [ ] S3 bucket created and accessible
- [ ] S3 bucket has versioning enabled
- [ ] S3 bucket has encryption enabled
- [ ] S3 bucket has public access blocked
- [ ] DynamoDB table created and active
- [ ] `terraform init` completed successfully
- [ ] `terraform state list` shows all resources
- [ ] `terraform plan` shows no changes (after fresh init)
- [ ] Local `terraform.tfstate` file removed or backed up

## Testing State Locking

Verify that state locking prevents concurrent modifications:

**Terminal 1** (lock state):
```bash
cd iac/
terraform apply -var-file=terraform.tfvars.prod
# Don't press Enter yet - this will acquire the lock
```

**Terminal 2** (attempt to acquire lock - should fail):
```bash
cd iac/
terraform apply -var-file=terraform.tfvars.prod
# Output: Resource already being managed by another Terraform instance
```

**Terminal 1**: Press `Ctrl+C` to release the lock

Expected behavior:
- Second terminal blocked while first terminal holds the lock
- Automatic lock release after ~30 seconds if process crashes
- DynamoDB table shows lock entry while locked

## Rollback (If Needed)

If you need to rollback to local state:

### 1. Restore Local Backend Configuration

Update `iac/backend.tf`:

```hcl
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
```

### 2. Reinitialize Terraform

```bash
cd iac/
terraform init

# When prompted: Copy existing state to new backend?
# Respond: yes
```

### 3. Verify Local State

```bash
# Check local state file exists
ls terraform.tfstate
terraform state list
```

## Best Practices

After migration:

1. **Share backend configuration** with your team in `backend.tf`
2. **Commit `backend.tf` to git** (does not contain secrets)
3. **Never commit `terraform.tfstate*`** to git (.gitignore already configured)
4. **Use IAM roles** for CI/CD systems (not long-lived access keys)
5. **Enable MFA** for IAM users with state management permissions
6. **Monitor S3 bucket** for unauthorized access (CloudTrail)
7. **Backup state regularly** (S3 versioning provides automatic backup)
8. **Test state restoration** annually (destroy and recreate from state)

## Troubleshooting

### Error: "Failed to create S3 bucket"

**Cause**: Bucket name already exists (S3 bucket names must be globally unique)

**Solution**: Use a more unique bucket name:
```bash
BUCKET_NAME="blog-cdn-terraform-state-$(date +%s)"
```

### Error: "AccessDenied: User is not authorized"

**Cause**: IAM permissions insufficient

**Solution**: Verify IAM policy includes S3 and DynamoDB permissions (see Prerequisites)

### Error: "DynamoDB table already exists"

**Cause**: Table creation attempted twice or manually created

**Solution**: Use existing table or delete and recreate:
```bash
aws dynamodb delete-table --table-name terraform-locks
# Wait for deletion, then retry table creation
```

### Error: "Failed to load state from S3"

**Cause**: S3 bucket access issue

**Solutions**:
1. Verify bucket exists: `aws s3 ls | grep blog-cdn-terraform-state`
2. Verify credentials: `aws sts get-caller-identity`
3. Verify bucket policy allows your access
4. Check bucket encryption settings

## Costs

**AWS costs for remote state** (typical small project):

- **S3**: ~$0.024/month (state file ~1 KB)
- **S3 Versioning**: ~$0.025/month (historical versions)
- **S3 Bucket Public Access Block**: Free
- **DynamoDB**: ~$1.25/month (on-demand, pay per request)
- **Total**: ~$1.30/month

## Next Steps

After successful migration:

1. Configure CI/CD to use remote state
2. Set up IAM roles for automation
3. Enable CloudTrail for audit logging
4. Document state backend in team wiki
5. Train team on new state management process

## References

- [Terraform S3 Backend Documentation](https://www.terraform.io/language/settings/backends/s3)
- [AWS S3 Security Best Practices](https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html)
- [DynamoDB State Locking](https://www.terraform.io/language/settings/backends/s3#dynamodb_table)

---

**Complete!** Your Terraform state is now managed in AWS S3 + DynamoDB with automatic locking and version history.
