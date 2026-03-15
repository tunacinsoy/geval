# HR Document Storage Infrastructure

Secure, cloud-based repository for HR documents with EU data residency, role-based access control, encryption at rest and in transit, and comprehensive audit logging.

## Overview

This Terraform infrastructure implements a production-grade HR document storage solution compliant with:
- **GDPR** (Article 32 - Data protection controls)
- **SOC 2 Type II** (Audit logging, access controls, encryption)
- **Data Protection Directive** (EU operations)

## Architecture

### Primary Components

- **S3 Bucket (eu-west-1, Ireland)**: Primary storage for HR documents with versioning and encryption
- **S3 Replica Bucket (eu-central-1, Frankfurt)**: Cross-region replication for disaster recovery
- **KMS Encryption**: Customer-managed encryption keys with annual rotation
- **IAM Roles**: Three-tier access structure (Admin/Manager/Staff)
- **CloudTrail**: API audit logging for compliance
- **S3 Access Logs**: Object-level access tracking
- **CloudWatch**: Dashboards and alarms for operational visibility

### Security Features

- **Encryption at rest**: AES-256 with AWS KMS customer-managed keys
- **Encryption in transit**: TLS 1.2+ enforced (aws:SecureTransport policy)
- **Access control**: Role-based IAM policies with principle of least privilege
- **MFA protection**: HR Admin deletions require MFA token
- **Versioning**: Document version history for recovery
- **Deletion protection**: MFA delete protection enabled
- **Audit trail**: CloudTrail + S3 access logs (2-year retention)

### Compliance Features

- **Data residency**: EU-only (Ireland + Frankfurt regions)
- **Audit logging**: All S3 API operations logged
- **Access control**: Three-tier IAM roles with explicit permissions
- **Encryption key rotation**: Automatic annual rotation
- **Backup/recovery**: Cross-region replication with RTO < 4h, RPO < 1h
- **Right to deletion**: Supported via permanent deletion with audit trail

## Prerequisites

### Software Requirements
- Terraform >= 1.5.0
- AWS CLI v2 (optional, for verification)
- AWS account with appropriate permissions

### AWS Permissions Required
```
s3:*
kms:*
iam:*
cloudtrail:*
cloudwatch:*
sns:*
logs:*
```

### Manual Prerequisites
1. **AWS Account Setup**:
   - Create separate AWS account for production (recommended)
   - Ensure multi-region support enabled

2. **Terraform State Backend**:
   - Create S3 bucket: `org-terraform-state-prod`
   - Create DynamoDB table: `terraform-locks-prod`
   - Enable versioning on state bucket

3. **Data Processing Agreement (DPA)**:
   - Ensure AWS has signed Data Processing Agreement
   - Verify GDPR compliance obligations

4. **MFA Setup** (for HR Admin):
   - Configure MFA device for HR Admin user
   - HR Admin cannot perform delete operations without MFA token

5. **User Authentication**:
   - Integrate with corporate identity provider (Active Directory, Okta, etc.)
   - Create IAM users/roles for HR personnel
   - Assign appropriate roles: HR Admin, HR Manager, HR Staff

## Deployment

### 1. Initialize Terraform
```bash
cd iac/
terraform init -var-file=terraform.tfvars.prod
```

### 2. Validate Configuration
```bash
terraform validate
terraform fmt -check
```

### 3. Review Plan
```bash
terraform plan -var-file=terraform.tfvars.prod -out=tfplan
```

**Expected resources**: ~30+ AWS resources including:
- 1 primary S3 bucket + 1 replica bucket
- 3 IAM roles + 4 IAM policies
- 2 KMS keys (primary + replica)
- 3 logging/audit buckets
- 1 CloudTrail trail
- 1 CloudWatch dashboard
- 6+ CloudWatch alarms
- 1 SNS topic

### 4. Apply Configuration
```bash
terraform apply tfplan
```

### 5. Verify Deployment
```bash
aws s3 ls org-hr-documents-prod
aws kms describe-key --key-id alias/s3-documents-prod
aws iam list-roles --query 'Roles[?contains(RoleName, `hr-`)]'
```

## Configuration

### Environment Variables

**Production** (`terraform.tfvars.prod`):
- `environment = "prod"`
- `bucket_name = "org-hr-documents-prod"`
- `mfa_delete_enabled = true`
- `cross_region_replication_enabled = true`
- `kms_key_rotation_enabled = true`

**Development** (optional, `terraform.tfvars.dev`):
- `environment = "dev"`
- `bucket_name = "org-hr-documents-dev"`
- `mfa_delete_enabled = false` (less strict)
- `cross_region_replication_enabled = false` (cost savings)

### Important Configuration Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `aws_region` | eu-west-1 | Primary region (Ireland) |
| `aws_region_replica` | eu-central-1 | Replica region (Frankfurt) |
| `versioning_enabled` | true | Enable S3 versioning |
| `mfa_delete_enabled` | true | Require MFA for deletes |
| `cross_region_replication_enabled` | true | Enable disaster recovery replication |
| `enable_cloudtrail_logging` | true | Enable API audit logging |
| `kms_key_rotation_enabled` | true | Annual KMS key rotation |
| `lifecycle_transition_days` | 90 | Days before transitioning to cheaper storage |
| `lifecycle_expiration_years` | 7 | Years before permanent expiration (per retention policy) |
| `backup_retention_days` | 30 | Days to retain versioned objects |

## Access Control

### Three-Tier Role Structure

**1. HR Admin Role**
- **Permissions**: Full access (upload, download, delete, archive, audit logs)
- **MFA Required**: Yes (for delete operations)
- **Use Cases**: Document management, user access provisioning, audit review
- **AWS CLI Example**:
  ```bash
  aws sts assume-role --role-arn arn:aws:iam::ACCOUNT:role/hr-admin-XXX \
    --role-session-name hr-admin-session \
    --serial-number arn:aws:iam::ACCOUNT:mfa/user
  ```

**2. HR Manager Role**
- **Permissions**: Upload, download, view documents, view versions
- **MFA Required**: No
- **Use Cases**: Day-to-day document management, sharing
- **AWS CLI Example**:
  ```bash
  aws sts assume-role --role-arn arn:aws:iam::ACCOUNT:role/hr-manager-XXX \
    --role-session-name hr-manager-session
  ```

**3. HR Staff Role**
- **Permissions**: Read-only access to assigned documents
- **MFA Required**: No
- **Use Cases**: Document access for HR staff, viewing records
- **AWS CLI Example**:
  ```bash
  aws sts assume-role --role-arn arn:aws:iam::ACCOUNT:role/hr-staff-XXX \
    --role-session-name hr-staff-session
  ```

### User Provisioning

1. Create IAM user in AWS console
2. Assign appropriate IAM role based on responsibilities
3. Configure AWS access keys (if needed) or federated identity
4. For HR Admin, configure MFA device
5. Document user access in compliance log

## Operational Procedures

### Backup & Recovery

**Automated Backup**:
- CloudTrail logs all S3 API calls (2-year retention)
- S3 versioning retains 30 days of versions
- Cross-region replication (continuous, near real-time)

**Manual Backup**:
```bash
# List all versions of a document
aws s3api list-object-versions \
  --bucket org-hr-documents-prod \
  --prefix "employee-records/"

# Restore a deleted object
aws s3api get-object \
  --bucket org-hr-documents-prod \
  --key "filename" \
  --version-id "VERSIONID" \
  restored-filename
```

### Disaster Recovery (Failover to Replica Region)

If primary region (eu-west-1) becomes unavailable:

1. Verify replica bucket data integrity
2. Update DNS/application configuration to point to replica
3. Promote replica bucket to primary (manual process)
4. Communicate with HR team about recovery status

**Manual failover steps**:
```bash
# Verify replica bucket has data
aws s3 ls org-hr-documents-replica --recursive

# Update applications to use replica
export AWS_REGION=eu-central-1
aws s3 ls org-hr-documents-replica
```

### Access Review (Quarterly)

1. Generate list of users with S3 access
2. Review each role assignment for necessity
3. Remove unused access (principle of least privilege)
4. Document review in compliance log

```bash
# List IAM users and their roles
aws iam get-credential-report

# List attached policies for a role
aws iam list-attached-role-policies --role-name hr-admin-XXX
```

### Encryption Key Rotation (Annual)

Automatic key rotation is enabled. Manual verification:
```bash
# Check key rotation status
aws kms get-key-rotation-status --key-id alias/s3-documents-prod

# View key rotation history
aws kms list-key-rotations --key-id alias/s3-documents-prod
```

## Monitoring & Alerts

### CloudWatch Dashboard

Access at: AWS Console → CloudWatch → Dashboards → `hr-documents-dashboard-prod`

**Metrics Displayed**:
- S3 bucket size (bytes and object count)
- API request volume (Get, Put, Delete)
- Failed requests (4xx, 5xx errors)
- Unauthorized access attempts
- Document upload/download activity

### Configured Alarms

| Alarm | Threshold | Action |
|-------|-----------|--------|
| Unauthorized Access | > 5 attempts in 5 min | SNS notification |
| Bucket Size Quota | > 900 GB (1 TB limit) | SNS notification |
| Replication Failures | Latency > 15 min | SNS notification |
| S3 4xx Errors | > 10 in 5 min | SNS notification |
| S3 5xx Errors | Any occurrence | SNS notification |
| Object Deletions | Any delete event | SNS notification (audit) |

### Configure Alert Recipients

```bash
# Subscribe email to SNS topic
aws sns subscribe \
  --topic-arn arn:aws:sns:eu-west-1:ACCOUNT:hr-documents-alerts-prod \
  --protocol email \
  --notification-endpoint your-email@company.com

# Confirm subscription via email link
```

## Compliance & Audit

### CloudTrail Audit Logs

All S3 API operations logged with:
- Timestamp
- User/role identity
- Operation (GetObject, PutObject, DeleteObject, etc.)
- IP address
- Success/failure status

**Query audit logs**:
```bash
# Find all document deletions in last 30 days
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=ResourceName,AttributeValue=org-hr-documents-prod \
  --max-items 50 \
  --region eu-west-1
```

### Compliance Validation

**GDPR Compliance Checklist**:
- [ ] Data residency in EU regions (ireland + Frankfurt)
- [ ] Encryption at rest and in transit enabled
- [ ] Access logging enabled (S3 + CloudTrail)
- [ ] Right to deletion supported (permanent delete with audit trail)
- [ ] Data Processing Agreement signed with AWS
- [ ] Key rotation configured (annual)
- [ ] User access reviewed quarterly

**SOC 2 Type II Checklist**:
- [ ] Audit logging enabled (CloudTrail 2-year retention)
- [ ] Access controls implemented (least privilege)
- [ ] Encryption enforced (KMS customer-managed keys)
- [ ] Monitoring dashboards configured
- [ ] Alerts configured for security events
- [ ] Disaster recovery tested

### Deletion Audit Trail

All deletions tracked in CloudTrail:
```bash
# Find all document deletions
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=DeleteObject \
  --region eu-west-1
```

## Troubleshooting

### Common Issues

**1. Replication Failures**
- Check replication metric in CloudWatch
- Verify replica bucket still exists
- Check KMS key access in primary and replica regions
- Solution: Check bucket replication configuration

```bash
# Verify replication configuration
aws s3api get-bucket-replication --bucket org-hr-documents-prod
```

**2. Access Denied Errors**
- Verify user has correct IAM role assigned
- Check KMS key policy allows the role
- Verify bucket policy allows the role
- Solution: Update IAM role or bucket/KMS policies

**3. Quota Limit Approaching**
- Review CloudWatch dashboard for bucket size
- Identify and delete old/unused documents
- Archive documents older than 7 years
- Solution: Run lifecycle cleanup manually or adjust retention

```bash
# Check bucket size
aws s3api list-objects-v2 --bucket org-hr-documents-prod --query 'StorageClass'
```

**4. CloudTrail Logs Not Appearing**
- Verify CloudTrail trail is enabled
- Check S3 bucket policy allows CloudTrail
- Verify log delivery role has permissions
- Solution: Re-enable trail or fix bucket policy

```bash
# Check trail status
aws cloudtrail describe-trails --trail-name-list hr-documents-trail-prod
```

## Cost Optimization

### Expected Monthly Costs

- **S3 Storage**: ~$10-50 (depends on usage, 500 GB at ~$0.023/GB)
- **KMS Operations**: ~$50-100 (encryption/decryption operations)
- **CloudTrail**: ~$50-100 (API logging)
- **Cross-region Replication**: ~$50-100 (data transfer)
- **Lifecycle Storage Classes**: ~$50-100 (tiering to cheaper classes)

**Total Estimated**: $210-450/month (well within $500-$1,500/month budget)

### Cost Reduction Strategies

1. **Use S3 Intelligent-Tiering**: Automatically move infrequently accessed data to cheaper tiers (after 90 days)
2. **Archive old documents**: Documents > 7 years moved to Glacier (per retention policy)
3. **Lifecycle policies**: Automatically expire/delete oldest versions
4. **Regional consolidation**: Use single primary region where possible
5. **On-demand DynamoDB**: State locking uses on-demand billing (no fixed costs)

## File Structure

```
iac/
├── backend.tf                  # State backend configuration (S3 + DynamoDB)
├── provider.tf                 # AWS provider configuration
├── versions.tf                 # Terraform and provider versions
├── kms.tf                       # KMS encryption keys
├── s3.tf                        # Primary S3 bucket
├── s3-logging.tf               # S3 access logs and CloudTrail buckets
├── s3-replication.tf           # Cross-region replication configuration
├── iam.tf                       # IAM roles and policies (3-tier structure)
├── cloudtrail.tf               # CloudTrail API logging
├── monitoring.tf               # CloudWatch dashboards and alarms
├── variables.tf                # Input variable declarations
├── outputs.tf                  # Output declarations
├── terraform.tfvars.prod       # Production environment variables
├── terraform.tfvars.dev        # Development environment variables (optional)
└── README.md                   # This file
```

## Support & Next Steps

1. **Deploy Infrastructure**:
   - Run `terraform apply` to provision resources
   - Verify all resources created successfully
   - Test access with each IAM role

2. **Configure User Access**:
   - Create IAM users for HR team
   - Assign appropriate roles
   - Test authentication and access

3. **Operational Handoff**:
   - Train HR team on access procedures
   - Configure alert recipients
   - Document recovery procedures

4. **Compliance Audit**:
   - Verify GDPR controls implemented
   - Validate SOC 2 audit logging
   - Schedule quarterly access reviews

5. **Ongoing Operations**:
   - Monitor CloudWatch dashboards
   - Review alerts and investigate issues
   - Perform quarterly access reviews
   - Test disaster recovery annually

## References

- [AWS S3 Documentation](https://docs.aws.amazon.com/s3/)
- [AWS KMS Documentation](https://docs.aws.amazon.com/kms/)
- [GDPR Article 32 - Data Protection](https://gdpr-info.eu/art-32-gdpr/)
- [SOC 2 Type II Compliance](https://www.aicpa.org/soc2)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)

---

**Last Updated**: 2026-03-09
**Infrastructure**: Secure HR Document Storage
**Environment**: Production
**Compliance**: GDPR + SOC 2 Type II
