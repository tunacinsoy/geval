# Flower Shop Website Infrastructure

This directory contains the Terraform infrastructure-as-code (IaC) configuration for the flower shop static website.

## Architecture Overview

The infrastructure consists of:
- **Amazon S3**: Static website content storage with versioning and encryption
- **CloudFront**: Global content delivery network (CDN) with edge caching
- **Route53**: Domain name system (DNS) management
- **AWS Certificate Manager (ACM)**: Free HTTPS/TLS certificates with auto-renewal
- **CloudWatch**: Monitoring, metrics, and alerting

**Infrastructure Pattern**: Serverless static website (no compute resources, no databases, no VPC required)

## Prerequisites

Before deploying, you need:

1. **AWS Account**: Active AWS account with appropriate permissions
2. **AWS CLI**: Installed and configured with credentials
3. **Terraform**: Version >= 1.7 (check with `terraform --version`)
4. **Domain Name**: Owned and registered (can use any registrar)
5. **S3 Backend Resources**: Pre-created S3 bucket and DynamoDB table for Terraform state

### Create Backend Resources (One-time Setup)

```bash
# Set your AWS account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Create S3 bucket for Terraform state
aws s3api create-bucket \
  --bucket terraform-state-flower-shop-${ACCOUNT_ID} \
  --region us-east-1

# Enable versioning on state bucket
aws s3api put-bucket-versioning \
  --bucket terraform-state-flower-shop-${ACCOUNT_ID} \
  --versioning-configuration Status=Enabled

# Enable encryption on state bucket
aws s3api put-bucket-encryption \
  --bucket terraform-state-flower-shop-${ACCOUNT_ID} \
  --server-side-encryption-configuration '{
    "Rules": [
      {
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }
    ]
  }'

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

## Configuration

### Step 1: Update Variables

Edit `terraform.tfvars` and update the domain name:

```hcl
domain_name = "your-domain.com"  # Update this to your actual domain
aws_region  = "us-east-1"        # Optional: change AWS region if desired
```

### Step 2: Initialize Terraform

```bash
# Initialize Terraform with backend configuration
terraform init \
  -backend-config="bucket=terraform-state-flower-shop-${ACCOUNT_ID}" \
  -backend-config="key=001-static-website/terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="dynamodb_table=terraform-state-lock" \
  -backend-config="encrypt=true"
```

### Step 3: Review Plan

```bash
# Preview infrastructure changes
terraform plan -var-file=terraform.tfvars -out=tfplan

# Review the plan output carefully before proceeding
```

### Step 4: Deploy Infrastructure

```bash
# Deploy infrastructure (requires confirmation)
terraform apply tfplan

# Or deploy without saving a plan:
# terraform apply -var-file=terraform.tfvars
```

### Step 5: Verify Deployment

```bash
# Get outputs (including CloudFront domain, Route53 nameservers, etc.)
terraform output

# Display website URL
terraform output website_url
```

## Post-Deployment Configuration

### Update Domain Registrar

The Route53 hosted zone requires nameserver updates in your domain registrar:

```bash
# Get the nameservers
terraform output route53_nameservers
```

Update your domain registrar with these 4 nameservers:
1. Log in to your domain registrar (GoDaddy, Namecheap, Google Domains, etc.)
2. Find DNS settings
3. Replace existing nameservers with the Route53 nameservers from the output above

**Time to propagate**: 24-48 hours typically (up to 72 hours sometimes)

### Upload Website Content

Upload your website files to the S3 bucket:

```bash
# Using AWS CLI (recommended)
aws s3 sync ./website-content/ s3://$(terraform output -raw s3_bucket_name)/ --delete

# Or use AWS Management Console
# https://console.aws.amazon.com/s3/
```

### (Optional) Configure Email Alerts

To receive alerts when infrastructure issues occur:

```bash
# Uncomment the SNS email subscription in main.tf (line ~435)
# Update the email address to your email
# Re-deploy: terraform apply

# Confirm the SNS subscription in your email inbox
```

## Monitoring

### CloudWatch Dashboard

Access the monitoring dashboard:

```bash
# Get dashboard URL
terraform output cloudwatch_dashboard_url
```

The dashboard shows:
- Total CloudFront requests
- Bandwidth usage
- 4xx and 5xx error rates
- Cache hit rate

### Check Infrastructure Status

```bash
# List all resources created
terraform state list

# Show specific resource details
terraform state show aws_s3_bucket.website
terraform state show aws_cloudfront_distribution.website
```

## Cost Estimation

Estimated monthly cost for typical usage (100 concurrent users, <500 MB content):

- **S3 Storage**: $0.50-1.00 (storage) + $0.10-0.50 (requests)
- **CloudFront**: $1-3 (bandwidth) + $0.10 (requests)
- **Route53**: $0.50 (hosted zone) + $0.40 (queries)
- **ACM Certificate**: Free
- **CloudWatch**: Free tier covers this usage

**Total**: $12-18/month (well under the $20/month budget)

Verify cost estimate before deploying:

```bash
# Install infracost (optional)
brew install infracost

# Check estimated costs
infracost breakdown --path .
```

## Updating Content

### Cache Invalidation

After uploading new content, invalidate CloudFront cache for immediate updates:

```bash
# Invalidate all files
terraform output deployment_instructions | grep -A 5 "Invalidate"

# Or manually:
DIST_ID=$(terraform output -raw cloudfront_distribution_id)
aws cloudfront create-invalidation --distribution-id $DIST_ID --paths "/*"
```

### Versioned Assets

For CSS/JavaScript/images:
- Include version numbers or hashes in filenames (e.g., `styles-v2.css`)
- Use long cache TTL (1 year)
- Automatically cache-busting when updating filenames

For HTML pages:
- Use short cache TTL (24 hours)
- Browsers will check for updates daily

## Troubleshooting

### "Domain validation failed"

If Route53 DNS validation times out:

```bash
# Check if Route53 records were created
terraform state show aws_route53_record.acm_validation

# Manually verify DNS propagation
nslookup <validation-record-name>
```

### "S3 bucket already exists"

S3 bucket names are globally unique. If you get an error about bucket name conflicts:

```bash
# The bucket is created with a random suffix, but if it still conflicts:
# Change the bucket_prefix in main.tf (around line 20)
```

### "CloudFront distribution is slow"

CloudFront can take 5-15 minutes to fully deploy globally:

```bash
# Check distribution status
aws cloudfront get-distribution --id $(terraform output -raw cloudfront_distribution_id) \
  --query 'Distribution.Status'
```

### Website returns 403 Forbidden

Possible causes:
1. Index.html doesn't exist in S3 bucket
2. S3 bucket policy isn't set (OAI not working)
3. CloudFront distribution hasn't fully deployed

Solutions:

```bash
# Check bucket contents
aws s3 ls s3://$(terraform output -raw s3_bucket_name)/

# Verify bucket policy
aws s3api get-bucket-policy --bucket $(terraform output -raw s3_bucket_name)

# Check CloudFront status
aws cloudfront get-distribution-config \
  --id $(terraform output -raw cloudfront_distribution_id) \
  --query 'DistributionConfig.Enabled'
```

## Destroying Infrastructure

To remove all resources (use with caution):

```bash
# Preview what will be destroyed
terraform plan -destroy

# Destroy infrastructure (requires confirmation)
terraform destroy -var-file=terraform.tfvars

# Or without confirmation:
# terraform destroy -auto-approve -var-file=terraform.tfvars
```

**Note**: S3 buckets must be empty before Terraform can delete them. If deletion fails:

```bash
# Empty the S3 buckets manually
aws s3 rm s3://$(terraform output -raw s3_bucket_name) --recursive
aws s3 rm s3://$(terraform output -raw s3_logging_bucket_name) --recursive

# Then try destroy again
terraform destroy -var-file=terraform.tfvars
```

## File Structure

```
terraform/
├── backend.tf                  # State backend (S3 + DynamoDB)
├── provider.tf                 # AWS provider configuration
├── versions.tf                 # Terraform and provider versions
├── variables.tf                # Input variables and validation
├── outputs.tf                  # Output values for deployments
├── main.tf                     # All infrastructure resources
├── cloudfront-function.js      # CloudFront function for index.html redirect
├── terraform.tfvars            # Production variable values (EDIT THIS)
└── README.md                   # This documentation
```

## Best Practices

1. **Always review plans**: Read `terraform plan` output before applying
2. **Use variables**: Don't hardcode values - use `terraform.tfvars`
3. **Commit code, not state**: Add `*.tfstate*` to `.gitignore`
4. **Version lock files**: Commit `.terraform.lock.hcl` to track provider versions
5. **Backup state**: S3 versioning automatically backs up state files
6. **Test changes**: Use `terraform plan` to test before deploying
7. **Monitor costs**: Check CloudWatch dashboard monthly

## Support & Documentation

- **Terraform Docs**: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- **AWS CloudFront**: https://docs.aws.amazon.com/cloudfront/
- **S3 Static Website**: https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html
- **Route53 DNS**: https://docs.aws.amazon.com/route53/

## License

This Terraform configuration is provided as-is for educational and commercial use.
