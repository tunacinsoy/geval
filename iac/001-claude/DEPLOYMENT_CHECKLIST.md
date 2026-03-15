# Deployment Checklist - Flower Shop Website

Use this checklist to verify the infrastructure is ready for deployment and to validate everything is working after deployment.

## Pre-Deployment Validation

### Prerequisites
- [ ] AWS account created and configured
- [ ] AWS CLI installed and credentials configured
- [ ] Terraform installed (>= 1.7)
- [ ] Domain name purchased and accessible
- [ ] S3 backend bucket created (see README.md)
- [ ] DynamoDB state lock table created (see README.md)

### Configuration
- [ ] `terraform.tfvars` updated with correct domain name
- [ ] `aws_region` set to desired AWS region
- [ ] All comments and examples removed from variable files
- [ ] No hardcoded credentials in any .tf files

### Code Quality
- [ ] `terraform fmt` applied (all .tf files formatted)
- [ ] `terraform validate` passes with no errors
- [ ] `terraform plan` produces expected resources
- [ ] No sensitive values exposed in plan output
- [ ] Security scanning (`tfsec`) shows no HIGH/CRITICAL findings

### Cost Review
- [ ] Cost estimate verified (< $20/month target)
- [ ] `infracost` preview reviewed (if available)
- [ ] Billing alerts configured in AWS account (optional)

---

## Deployment Steps

### Step 1: Initialize Backend
- [ ] Backend bucket and DynamoDB table verified to exist
- [ ] `terraform init` completed successfully
- [ ] `.terraform/` directory created
- [ ] `.terraform.lock.hcl` created and reviewed

### Step 2: Review Plan
- [ ] `terraform plan` executed
- [ ] Plan saved to file (`tfplan`)
- [ ] Plan output reviewed for correctness:
  - [ ] S3 buckets being created
  - [ ] CloudFront distribution being created
  - [ ] Route53 hosted zone being created
  - [ ] ACM certificate being created
  - [ ] No unexpected resource deletions
- [ ] All resource names appear correct

### Step 3: Deploy Infrastructure
- [ ] `terraform apply tfplan` executed
- [ ] All resources created successfully (no errors)
- [ ] Terraform outputs displayed
- [ ] State file stored in S3 backend

### Step 4: Verify AWS Console
Check that resources exist in AWS Management Console:
- [ ] S3 bucket exists (check for versioning, encryption)
- [ ] Logging S3 bucket exists
- [ ] CloudFront distribution exists
  - [ ] Distribution status shows "Deployed" (may take 5-15 minutes)
  - [ ] Custom domain (CNAME) configured
  - [ ] SSL certificate attached
- [ ] Route53 hosted zone exists
  - [ ] Nameservers visible and noted
  - [ ] DNS records created (A, AAAA, ACM validation)
- [ ] ACM certificate exists
  - [ ] Status shows "Issued" (after DNS validation)
  - [ ] Domain verified

---

## Post-Deployment Configuration

### Domain Registrar Update
- [ ] Route53 nameservers obtained: `terraform output route53_nameservers`
- [ ] Domain registrar nameservers updated (GoDaddy, Namecheap, etc.)
- [ ] Nameserver changes propagating (check again in 24-48 hours):
  ```bash
  dig +short NS your-domain.com
  ```

### Website Content Upload
- [ ] Website files ready (HTML, CSS, JavaScript, images)
- [ ] Website structure:
  - [ ] `index.html` in root directory
  - [ ] CSS/JS in `/css` and `/js` subdirectories
  - [ ] Images in `/images` subdirectory
- [ ] Files uploaded to S3:
  ```bash
  aws s3 sync ./website-content/ s3://$(terraform output -raw s3_bucket_name)/ --delete
  ```
- [ ] Files verified in S3 console

### Monitoring Configuration
- [ ] CloudWatch dashboard accessible
- [ ] Alarms configured (optional - SNS email subscriptions)
- [ ] CloudFront access logs being written to S3

---

## Post-Deployment Validation

### Domain & DNS
- [ ] Domain resolves to CloudFront:
  ```bash
  dig your-domain.com
  ```
  Should show CloudFront distribution domain
- [ ] Both A and AAAA records working:
  ```bash
  nslookup your-domain.com
  dig your-domain.com AAAA
  ```
- [ ] DNS propagation complete (all nameservers return same IP)

### HTTPS & Certificates
- [ ] HTTPS works (visit https://your-domain.com)
- [ ] SSL certificate is valid (browser shows padlock icon)
- [ ] Certificate details correct:
  - [ ] Domain name matches
  - [ ] Issued by AWS Certificate Manager
  - [ ] No expiration warning
- [ ] HTTP redirects to HTTPS:
  ```bash
  curl -i http://your-domain.com
  # Should show 308 redirect to https://
  ```

### Website Functionality
- [ ] Home page loads (index.html)
- [ ] Page load time < 2 seconds
- [ ] Images load correctly and quickly
- [ ] Links work correctly
- [ ] CSS and JavaScript load properly
- [ ] Mobile responsiveness verified
- [ ] Different pages accessible:
  - [ ] /index.html
  - [ ] /about.html (if exists)
  - [ ] /contact.html (if exists)

### CloudFront Caching
- [ ] HTML caching working (24-hour TTL):
  ```bash
  curl -i https://your-domain.com
  # Check headers: Cache-Control, ETag
  ```
- [ ] Asset caching working (1-year TTL for /images, /css, /js)
- [ ] Cache invalidation working (if test updated files):
  ```bash
  DIST_ID=$(terraform output -raw cloudfront_distribution_id)
  aws cloudfront create-invalidation --distribution-id $DIST_ID --paths "/*"
  # Should return invalidation ID
  ```

### Access Logs
- [ ] CloudFront logs being written:
  ```bash
  aws s3 ls s3://$(terraform output -raw s3_logging_bucket_name)/cloudfront-logs/
  ```
- [ ] S3 access logs being written:
  ```bash
  aws s3 ls s3://$(terraform output -raw s3_logging_bucket_name)/s3-access-logs/
  ```

### Monitoring & Alerts
- [ ] CloudWatch metrics showing traffic:
  - [ ] Requests metric > 0
  - [ ] Cache hit rate > 50%
  - [ ] Error rates near 0%
- [ ] (Optional) SNS email alerts configured and tested
- [ ] Alert thresholds set appropriately

### Cost Verification
- [ ] AWS Billing console shows costs < $20/month
- [ ] S3 storage cost reasonable (< $2)
- [ ] CloudFront bandwidth cost reasonable (< $5)
- [ ] No unexpected costs appearing
- [ ] CloudWatch alarms not triggering unexpectedly

---

## Go-Live Sign-Off

### Infrastructure Ready
- [ ] All deployment steps completed ✓
- [ ] All validation items checked ✓
- [ ] Website fully functional ✓
- [ ] Monitoring configured ✓
- [ ] Cost tracking verified ✓

### Stakeholder Approval
- [ ] Website owner reviewed and approved
- [ ] Domain correctly configured
- [ ] All content uploaded and verified
- [ ] Performance expectations met

### Operations Readiness
- [ ] Documentation reviewed (README.md)
- [ ] Runbooks created for common tasks:
  - [ ] How to update content
  - [ ] How to invalidate cache
  - [ ] How to add pages
  - [ ] How to monitor for issues
  - [ ] How to troubleshoot problems
- [ ] Backup/disaster recovery process documented
- [ ] Support contact information documented

### Sign-Off
- [ ] **Deployment Date**: _______________
- [ ] **Deployed By**: _______________
- [ ] **Approved By**: _______________
- [ ] **Notes**: _______________________________________________________

---

## Ongoing Maintenance

### Monthly Tasks
- [ ] Review CloudWatch metrics for anomalies
- [ ] Check AWS billing for unexpected costs
- [ ] Verify CloudFront distribution status ("Deployed")
- [ ] Check CloudWatch alarms haven't been triggered

### When Updating Website
- [ ] Update content in website-content/ directory
- [ ] Test changes locally before uploading
- [ ] Upload to S3: `aws s3 sync ./website-content/ s3://bucket-name/ --delete`
- [ ] Invalidate CloudFront cache if immediate update needed

### Security & Patches
- [ ] AWS patches applied automatically (no action needed)
- [ ] Certificate auto-renewal verified (ACM handles automatically)
- [ ] Review access logs monthly for suspicious activity
- [ ] Verify S3 bucket policies remain restrictive

### Disaster Recovery
- [ ] S3 versioning enabled (automatic backups)
- [ ] Git repository contains website source
- [ ] Terraform state backed up in S3 (with versioning)
- [ ] Recovery procedure tested (restore from backup):
  - [ ] Delete current S3 files
  - [ ] Upload previous version from git/backup
  - [ ] Invalidate CloudFront cache

---

## Rollback Procedure

If issues occur after deployment:

### Option 1: Revert to Previous Website Version
```bash
# List S3 versions
aws s3api list-object-versions \
  --bucket $(terraform output -raw s3_bucket_name)

# Restore specific version
aws s3api copy-object \
  --bucket $(terraform output -raw s3_bucket_name) \
  --copy-source "bucket/key?versionId=VersionId" \
  --key "key"
```

### Option 2: Destroy and Redeploy Infrastructure
```bash
# Backup current S3 content first
aws s3 sync s3://$(terraform output -raw s3_bucket_name)/ ./backup/

# Destroy
terraform destroy -var-file=terraform.tfvars -auto-approve

# Redeploy
terraform apply -var-file=terraform.tfvars -auto-approve
```

### Option 3: Roll Back to Previous Terraform State
```bash
# List previous states in S3
aws s3api list-object-versions \
  --bucket terraform-state-flower-shop-* \
  --prefix "001-static-website/terraform.tfstate"

# Restore previous state
aws s3api get-object \
  --bucket terraform-state-flower-shop-* \
  --key "001-static-website/terraform.tfstate" \
  --version-id "VersionId" \
  terraform.tfstate

# Re-apply
terraform apply -var-file=terraform.tfvars -auto-approve
```

---

## Troubleshooting Reference

See `README.md` for detailed troubleshooting guides:
- Domain validation failed
- S3 bucket already exists
- CloudFront distribution is slow
- Website returns 403 Forbidden
- Other common issues

---

**Last Updated**: 2026-02-12
**Terraform Version**: 1.7+
**AWS Provider Version**: 5.40+
**Status**: Ready for Production Deployment
