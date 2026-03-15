# HR Document Storage - Deployment Runbook

## Overview

This runbook provides step-by-step procedures for deploying, managing, and recovering HR document storage infrastructure.

## Table of Contents

1. [Pre-Deployment Checklist](#pre-deployment-checklist)
2. [Initial Deployment](#initial-deployment)
3. [Post-Deployment Verification](#post-deployment-verification)
4. [User Provisioning](#user-provisioning)
5. [Backup & Recovery Procedures](#backup--recovery-procedures)
6. [Disaster Recovery](#disaster-recovery)
7. [Operational Procedures](#operational-procedures)
8. [Troubleshooting](#troubleshooting)

---

## Pre-Deployment Checklist

### Prerequisites

- [ ] AWS account created with appropriate permissions
- [ ] Terraform >= 1.5.0 installed locally
- [ ] AWS CLI v2 installed and configured
- [ ] AWS credentials configured with appropriate IAM permissions
- [ ] S3 bucket created for Terraform state: `org-terraform-state-prod`
- [ ] DynamoDB table created for state locking: `terraform-locks-prod`
- [ ] Data Processing Agreement (DPA) signed with AWS for GDPR compliance
- [ ] KMS key created in both eu-west-1 and eu-central-1 for encrypting state
- [ ] MFA device provisioned for HR Admin user

### Compliance Verification

- [ ] GDPR compliance requirements reviewed
- [ ] SOC 2 Type II audit requirements documented
- [ ] Data residency requirements confirmed (EU-only)
- [ ] Legal team approval obtained for infrastructure
- [ ] HR policies updated to reference new system

---

## Initial Deployment

### Step 1: Prepare Local Environment

```bash
# Clone repository
git clone <repository-url>
cd pw-sdd-iac-claude-001

# Verify Terraform version
terraform version
# Expected output: Terraform v1.5.0 or higher

# Verify AWS credentials
aws sts get-caller-identity
# Expected output: Account ID, User ARN, etc.
```

### Step 2: Initialize Terraform Backend

```bash
cd iac/

# Initialize with production configuration
terraform init -var-file=terraform.tfvars.prod

# Expected output:
# - Backend configuration loaded
# - AWS provider downloaded
# - Modules initialized
# - Ready to plan
```

**Troubleshooting**:
- If backend fails: Verify S3 bucket and DynamoDB table exist and are accessible
- If provider fails: Check AWS credentials and permissions

### Step 3: Validate Configuration

```bash
# Validate Terraform syntax
terraform validate

# Expected output:
# Success! The configuration is valid.

# Format code to standard style
terraform fmt -recursive

# Check for security issues with tfsec (if installed)
tfsec iac/
```

### Step 4: Review Deployment Plan

```bash
# Generate plan for production
terraform plan -var-file=terraform.tfvars.prod -out=tfplan

# Review plan output:
# - Should show ~30+ resources to create
# - No resources destroyed or modified
# - All regional resources in eu-west-1 and eu-central-1
```

**Expected Resource Count**:
- 2 S3 buckets (primary + replica)
- 3 IAM roles
- 4 IAM policies
- 2 KMS keys
- 3 logging buckets
- 1 CloudTrail trail
- 1 CloudWatch dashboard
- 6 CloudWatch alarms
- 1 SNS topic
- Plus supporting resources (versions, KMS aliases, etc.)

### Step 5: Apply Deployment

```bash
# Apply the plan
terraform apply tfplan

# Expected output:
# - "Apply complete! Resources: XX added, 0 changed, 0 destroyed"
# - Outputs displayed showing resource IDs and ARNs

# Save outputs for reference
terraform output -json > deployment-outputs.json
```

**⚠️ CRITICAL**: This step will:
- Create S3 buckets for document storage
- Create KMS encryption keys
- Create IAM roles and policies
- Create CloudTrail trail (starts logging immediately)
- Create CloudWatch alarms (starts monitoring immediately)

**Estimated Deployment Time**: 5-10 minutes

### Step 6: Verify Deployment

```bash
# Check Terraform state
terraform state list

# Verify key resources created
aws s3 ls org-hr-documents-prod
aws kms describe-key --key-id alias/s3-documents-prod
aws iam list-roles --query 'Roles[?contains(RoleName, `hr-`)]'

# Verify CloudTrail is logging
aws cloudtrail describe-trails --trail-name-list hr-documents-trail-prod
```

---

## Post-Deployment Verification

### Security Validation

**1. Verify Encryption is Enabled**
```bash
# Check S3 bucket encryption
aws s3api get-bucket-encryption --bucket org-hr-documents-prod

# Expected: aws:kms encryption with customer-managed key
```

**2. Verify Versioning is Enabled**
```bash
# Check bucket versioning
aws s3api get-bucket-versioning --bucket org-hr-documents-prod

# Expected: Status = Enabled
```

**3. Verify Public Access is Blocked**
```bash
# Check public access block
aws s3api get-public-access-block --bucket org-hr-documents-prod

# Expected: All four block settings = true
```

**4. Verify IAM Policies Have Explicit ARNs**
```bash
# Check HR Admin policy
aws iam get-role-policy --role-name <ADMIN_ROLE> --policy-name <POLICY_NAME>

# Expected: No wildcard (*) permissions
```

**5. Verify CloudTrail Logging**
```bash
# Check CloudTrail status
aws cloudtrail get-trail-status --name hr-documents-trail-prod

# Expected: IsLogging = true, HasCustomEventSelectors = true
```

### Performance Validation

**1. Test S3 Upload/Download**
```bash
# Create test file
echo "Test document" > test-doc.txt

# Upload with each role (simulated)
# - HR Admin: Should succeed
# - HR Manager: Should succeed
# - HR Staff: Should fail (no PutObject)

# Upload test
aws s3 cp test-doc.txt s3://org-hr-documents-prod/test/

# Download test
aws s3 cp s3://org-hr-documents-prod/test/test-doc.txt downloaded-doc.txt

# Verify encryption in transit (TLS)
# - Connection should use TLS 1.2+
```

**2. Test Replication**
```bash
# Wait 15 minutes for replication
sleep 900

# Verify object appears in replica bucket
aws s3api list-objects-v2 \
  --bucket org-hr-documents-replica \
  --region eu-central-1 \
  --profile replica

# Expected: test-doc.txt appears in replica
```

**3. Check CloudWatch Metrics**
```bash
# Wait 5-10 minutes for metrics to appear in CloudWatch
aws cloudwatch get-metric-statistics \
  --namespace AWS/S3 \
  --metric-name BucketSizeBytes \
  --dimensions Name=BucketName,Value=org-hr-documents-prod \
  --start-time $(date -u -d '10 minutes ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 300 \
  --statistics Average

# Expected: Metrics appear with test file size
```

### Compliance Validation

**1. Verify Data Residency**
```bash
# Confirm primary bucket is in Ireland
aws s3api get-bucket-location --bucket org-hr-documents-prod
# Expected: eu-west-1

# Confirm replica is in Frankfurt
aws s3api get-bucket-location \
  --bucket org-hr-documents-replica \
  --region eu-central-1
# Expected: eu-central-1
```

**2. Verify Audit Logging**
```bash
# Check CloudTrail logs in S3
aws s3api list-objects-v2 \
  --bucket org-cloudtrail-logs-prod \
  --prefix AWSLogs/

# Expected: CloudTrail log files present
```

**3. Verify GDPR Controls**
```bash
# Test MFA delete protection
# (HR Admin should not be able to delete without MFA)

# Test right to deletion
# (Documents can be permanently deleted with audit trail)
```

---

## User Provisioning

### Create HR Admin User

```bash
# Create IAM user
aws iam create-user --user-name hr-admin-john-doe

# Create access key
aws iam create-access-key --user-name hr-admin-john-doe

# Attach HR Admin role (for assume role)
aws iam attach-user-policy \
  --user-name hr-admin-john-doe \
  --policy-arn arn:aws:iam::ACCOUNT:policy/AssumeHRAdminRole

# Configure MFA (CRITICAL)
# 1. Get MFA serial number
aws iam create-virtual-mfa-device \
  --virtual-mfa-device-name hr-admin-john-doe

# 2. User configures MFA in AWS console or mobile app
# 3. Verify MFA with temporary codes
```

### Create HR Manager User

```bash
# Create IAM user
aws iam create-user --user-name hr-manager-jane-smith

# Create access key
aws iam create-access-key --user-name hr-manager-jane-smith

# Attach HR Manager role
aws iam attach-user-policy \
  --user-name hr-manager-jane-smith \
  --policy-arn arn:aws:iam::ACCOUNT:policy/AssumeHRManagerRole

# MFA not required for Manager role
```

### Create HR Staff User

```bash
# Create IAM user
aws iam create-user --user-name hr-staff-bob-wilson

# Create access key
aws iam create-access-key --user-name hr-staff-bob-wilson

# Attach HR Staff role
aws iam attach-user-policy \
  --user-name hr-staff-bob-wilson \
  --policy-arn arn:aws:iam::ACCOUNT:policy/AssumeHRStaffRole

# MFA not required for Staff role
```

### Test Access

```bash
# Test HR Admin access
aws sts assume-role \
  --role-arn arn:aws:iam::ACCOUNT:role/hr-admin-XXXXX \
  --role-session-name test-admin-session \
  --serial-number arn:aws:iam::ACCOUNT:mfa/hr-admin-john-doe \
  --token-code 123456  # 6-digit MFA code

# Export temporary credentials and test S3 access
export AWS_ACCESS_KEY_ID=<temporary-key>
export AWS_SECRET_ACCESS_KEY=<temporary-secret>
export AWS_SESSION_TOKEN=<session-token>

aws s3 ls org-hr-documents-prod
# Expected: List of documents or empty bucket
```

---

## Backup & Recovery Procedures

### Automated Backups

Your infrastructure has three layers of backups:

1. **S3 Versioning**: Retains 30 days of versions
2. **Cross-Region Replication**: Real-time copy to eu-central-1
3. **CloudTrail Logs**: 2-year audit trail in CloudTrail logs bucket

### Manual Backup (Optional)

```bash
# Sync entire bucket to local storage
aws s3 sync s3://org-hr-documents-prod/ ./backups/hr-documents-latest/

# Compress backup
tar -czf hr-documents-backup-$(date +%Y%m%d).tar.gz ./backups/

# Store backup securely (encrypt with GPG, store offline, etc.)
```

### Recovery Procedures

#### Recover Deleted Document (within 30 days)

```bash
# List all versions of a specific file
aws s3api list-object-versions \
  --bucket org-hr-documents-prod \
  --prefix "employee-records/john-doe.pdf"

# Find the deleted version (should have DeleteMarker or VersionId)

# Restore the object
aws s3api get-object \
  --bucket org-hr-documents-prod \
  --key "employee-records/john-doe.pdf" \
  --version-id "VERSIONID" \
  john-doe-recovered.pdf

# Re-upload if needed
aws s3 cp john-doe-recovered.pdf \
  s3://org-hr-documents-prod/employee-records/john-doe.pdf
```

#### Recover Bulk Deletions

```bash
# Use CloudTrail to find what was deleted
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=DeleteObject \
  --max-items 50

# For each deleted object, restore from version history
# Or restore from replica bucket in eu-central-1
```

#### Restore from Replica (Disaster Recovery)

```bash
# If primary bucket is inaccessible, use replica
aws s3 sync \
  s3://org-hr-documents-replica/ \
  s3://org-hr-documents-prod/ \
  --region eu-central-1

# Verify replication is complete
aws s3api list-objects-v2 --bucket org-hr-documents-prod
```

---

## Disaster Recovery

### Scenario: Primary Region (Ireland) Becomes Unavailable

**RTO**: < 4 hours
**RPO**: < 1 hour

#### Step 1: Assess Situation
```bash
# Try to access primary bucket
aws s3 ls org-hr-documents-prod

# If fails, assume primary region is down
# Check AWS status dashboard: https://status.aws.amazon.com/
```

#### Step 2: Verify Replica Data
```bash
# Verify replica bucket has recent data
aws s3api list-objects-v2 \
  --bucket org-hr-documents-replica \
  --region eu-central-1

# Check last replication time
aws cloudwatch get-metric-statistics \
  --namespace AWS/S3 \
  --metric-name ReplicationLatency \
  --dimensions Name=SourceBucket,Value=org-hr-documents-prod \
  --start-time $(date -u -d '2 hours ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 300 \
  --statistics Maximum \
  --region eu-central-1
```

#### Step 3: Promote Replica to Primary
```bash
# Update applications to use replica region
export AWS_REGION=eu-central-1

# Verify access to replica
aws s3 ls org-hr-documents-replica

# Update DNS/application configuration
# - Point document access to eu-central-1
# - Notify HR team of temporary access location
```

#### Step 4: Notify Stakeholders
- [ ] Notify HR team of incident
- [ ] Provide temporary access instructions
- [ ] Estimate recovery time
- [ ] Update status page

#### Step 5: Recovery When Primary is Available
```bash
# When eu-west-1 is back online, resume normal operations
# Option 1: Keep using replica, then sync back to primary
# Option 2: Failback to primary once verified operational

# Resync from replica to primary
aws s3 sync \
  s3://org-hr-documents-replica/ \
  s3://org-hr-documents-prod/ \
  --region eu-central-1

# Verify replication resumed
aws s3api get-bucket-replication --bucket org-hr-documents-prod
```

#### Step 6: Post-Incident
- [ ] Document what happened
- [ ] Update runbook with lessons learned
- [ ] Schedule disaster recovery drill quarterly

---

## Operational Procedures

### Daily Operations

**Morning Check**
```bash
# Review CloudWatch dashboard
aws cloudwatch get-dashboard --dashboard-name hr-documents-dashboard-prod

# Check alarms for any overnight issues
aws cloudwatch describe-alarms --alarm-names \
  "hr-documents-unauthorized-access-prod" \
  "hr-documents-bucket-size-quota-prod" \
  "hr-documents-replication-failures-prod"
```

**Weekly Review**
```bash
# Check CloudTrail for suspicious activity
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=DeleteObject \
  --max-items 20

# Review access logs
aws s3 sync s3://org-s3-access-logs-prod logs/
head -20 logs/s3-access-logs/*
```

### Monthly Operations

**Access Review**
```bash
# List all users with S3 access
aws iam get-credential-report | head -50

# Review role assignments
for role in hr-admin hr-manager hr-staff; do
  echo "=== $role ==="
  aws iam list-role-users --role-name $role
done

# Document review in compliance log
```

**Cost Review**
```bash
# Check S3 bucket size
aws s3api list-objects-v2 \
  --bucket org-hr-documents-prod \
  --query '[StorageClass, sum(Contents[].Size)]'

# Estimate costs
# S3: $0.023/GB * size_in_GB
# KMS: ~$1 per 10k requests
# CloudTrail: $0.10 per 100k events
```

**Replication Health**
```bash
# Verify replication metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/S3 \
  --metric-name ReplicationLatency \
  --start-time $(date -u -d '30 days ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 86400 \
  --statistics Maximum,Average
```

### Quarterly Operations

**Disaster Recovery Drill**
```bash
# Test failover to replica
# 1. Simulate primary region failure
# 2. Verify replica bucket has all data
# 3. Test accessing documents from replica
# 4. Document findings and update procedures

# Example: Try accessing replica directly
aws s3 ls org-hr-documents-replica --region eu-central-1
```

**Security Audit**
```bash
# Run Checkov to verify compliance
checkov --framework terraform --directory iac/

# Review IAM policies for least privilege
aws iam list-role-policies --role-name hr-admin-XXXXX

# Verify encryption is enabled
aws s3api get-bucket-encryption --bucket org-hr-documents-prod
```

**Access Log Review**
```bash
# Analyze access patterns
# - Who is accessing documents?
# - What documents are accessed most?
# - Are there any suspicious patterns?

aws s3 sync s3://org-s3-access-logs-prod quarterly-logs/
# Manual analysis of log files
```

**Annual Operations**

**KMS Key Rotation**
```bash
# Verify automatic rotation is enabled
aws kms get-key-rotation-status --key-id alias/s3-documents-prod

# View rotation history
aws kms list-key-rotations --key-id alias/s3-documents-prod

# Manual rotation (if needed)
aws kms rotate-key --key-id alias/s3-documents-prod
```

**Compliance Review**
- [ ] Verify GDPR controls still in place
- [ ] Validate SOC 2 audit documentation
- [ ] Review Data Processing Agreement with AWS
- [ ] Update compliance matrix

---

## Troubleshooting

### S3 Access Issues

**Symptom**: "Access Denied" when trying to upload/download

**Diagnosis**:
```bash
# Check user's role
aws iam list-attached-user-policies --user-name <USER>

# Check if role exists
aws iam get-role --role-name <ROLE>

# Check role trust relationship
aws iam get-role --role-name <ROLE> --query 'Role.AssumeRolePolicyDocument'

# Check KMS key access
aws kms decrypt --ciphertext-blob <BLOB> --key-id <KMS_KEY_ID>
```

**Solutions**:
- Verify user has correct role attached
- Verify role trust policy allows assume-role
- Check KMS key policy allows role access
- Verify bucket policy allows role access

### Replication Not Working

**Symptom**: Objects not appearing in replica bucket

**Diagnosis**:
```bash
# Check replication configuration
aws s3api get-bucket-replication --bucket org-hr-documents-prod

# Check replication role permissions
aws iam get-role-policy --role-name s3-replication-XXXXX --policy-name <POLICY>

# Check replication metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/S3 \
  --metric-name ReplicationLatency \
  --dimensions Name=SourceBucket,Value=org-hr-documents-prod
```

**Solutions**:
- Verify replication role exists and has permissions
- Check KMS keys in both regions are accessible
- Verify replica bucket exists and has encryption configured
- Re-enable replication configuration if needed

### CloudTrail Logs Not Appearing

**Symptom**: No CloudTrail events in logs bucket

**Diagnosis**:
```bash
# Check CloudTrail status
aws cloudtrail describe-trails --trail-name hr-documents-trail-prod

# Check CloudTrail is logging
aws cloudtrail get-trail-status --name hr-documents-trail-prod

# Verify logs bucket exists and has bucket policy
aws s3api get-bucket-policy --bucket org-cloudtrail-logs-prod
```

**Solutions**:
- Enable CloudTrail if disabled
- Fix S3 bucket policy for CloudTrail access
- Check CloudTrail logs bucket lifecycle policy (may be deleting old logs)
- Restart CloudTrail service

### High Costs

**Symptom**: AWS bill higher than expected

**Diagnosis**:
```bash
# Check bucket size
aws s3api list-objects-v2 --bucket org-hr-documents-prod \
  --query 'sum(Contents[].Size)'

# Check access log size
aws s3api list-objects-v2 --bucket org-s3-access-logs-prod \
  --query 'sum(Contents[].Size)'

# Check CloudTrail log size
aws s3api list-objects-v2 --bucket org-cloudtrail-logs-prod \
  --query 'sum(Contents[].Size)'

# Check KMS key usage
aws kms get-key-rotation-status --key-id alias/s3-documents-prod
```

**Solutions**:
- Delete old/unused documents
- Set lifecycle policies to transition to cheaper storage
- Delete old access logs (lifecycle policy)
- Review KMS operations volume (may be able to reduce)

---

## Appendix: Useful Commands

### List All Infrastructure

```bash
terraform show
terraform state list
```

### Destroy Infrastructure (Use with Caution!)

```bash
# Plan destruction
terraform plan -destroy -var-file=terraform.tfvars.prod

# Apply destruction
terraform apply -destroy -var-file=terraform.tfvars.prod

# WARNING: This permanently deletes all resources!
# Be sure to have backups before destroying!
```

### Update Infrastructure

```bash
# After modifying .tf files
terraform plan -var-file=terraform.tfvars.prod
terraform apply -var-file=terraform.tfvars.prod
```

### Emergency Access (if IAM is misconfigured)

```bash
# Root account access (LAST RESORT)
# - Login with root AWS account credentials
# - Fix IAM policies
# - Restore proper access

# DO NOT use root account for regular operations!
```

---

**Last Updated**: 2026-03-09
**Infrastructure**: Secure HR Document Storage
**Contact**: Infrastructure Team
