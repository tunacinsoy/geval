# Hardened AMI with CIS Benchmarks and Zero-Downtime Patching

## Overview

This Terraform infrastructure implements an automated, hardened AMI generation and zero-downtime instance patching system for AWS. The solution combines EC2 Image Builder with Ansible-driven CIS Level 1 hardening, Auto Scaling Groups with canary deployment, and Application Load Balancers for zero-downtime rolling updates.

## Architecture

- **Image Builder Pipeline**: Nightly scheduled builds with CIS Level 1 hardening via Ansible
- **Auto Scaling Group**: 50-500 instances with canary deployment strategy (10-20% validation)
- **Load Balancer**: Multi-AZ ALB with TLS 1.2+, connection draining (30 seconds)
- **Monitoring**: CloudWatch Logs, Alarms for build/refresh failures, SNS notifications
- **Compliance**: CIS Level 1 mandatory validation gate, GDPR audit logging (3-year retention)

## Prerequisites

- AWS Account with appropriate permissions
- Terraform 1.12+ installed
- AWS CLI configured with credentials
- Git for version control
- EC2 key pair for SSH access (optional, for debugging)

## Environment Setup

### 1. Initialize Terraform Backend

For production use, create an S3 bucket and DynamoDB table:

```bash
# Create S3 bucket for state
aws s3api create-bucket \
  --bucket my-project-terraform-state-123456789 \
  --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket my-project-terraform-state-123456789 \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket my-project-terraform-state-123456789 \
  --server-side-encryption-configuration '{
    "Rules": [
      {
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }
    ]
  }'

# Create DynamoDB table for locking
aws dynamodb create-table \
  --table-name my-project-terraform-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

### 2. Create SSH Key Pair (Optional)

```bash
mkdir -p keys
ssh-keygen -t rsa -b 4096 -f keys/deployment -N ""
```

### 3. Initialize Terraform Workspaces

```bash
terraform init \
  -backend-config="bucket=my-project-terraform-state-123456789" \
  -backend-config="key=001-ami-hardening-pipeline/terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="dynamodb_table=my-project-terraform-lock" \
  -backend-config="encrypt=true"

# Create workspaces
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```

## Deployment

### Development Environment

```bash
# Select dev workspace
terraform workspace select dev

# Review plan
terraform plan -var-file=terraform.tfvars.dev

# Apply configuration
terraform apply -var-file=terraform.tfvars.dev

# Get outputs
terraform output
```

### Staging Environment

```bash
terraform workspace select staging
terraform plan -var-file=terraform.tfvars.staging
terraform apply -var-file=terraform.tfvars.staging
```

### Production Environment

```bash
terraform workspace select prod
terraform plan -var-file=terraform.tfvars.prod
terraform apply -var-file=terraform.tfvars.prod
```

## Operations

### Trigger Image Build

```bash
# Get pipeline ARN from outputs
PIPELINE_ARN=$(terraform output -raw imagebuilder_pipeline_arn)

# Start build
aws imagebuilder start-image-pipeline-execution \
  --image-pipeline-arn $PIPELINE_ARN

# Monitor build progress
aws logs tail /aws/imagebuilder/ami-hardening-pipeline-<env> --follow
```

### Trigger Instance Refresh

```bash
# Get ASG name
ASG_NAME=$(terraform output -raw asg_name)

# Start instance refresh
aws autoscaling start-instance-refresh \
  --auto-scaling-group-name $ASG_NAME \
  --preferences '{"MinHealthyPercentage": 75, "CheckpointPercentage": 20, "CheckpointDelay": 600}'

# Monitor refresh progress
aws autoscaling describe-instance-refreshes \
  --auto-scaling-group-name $ASG_NAME \
  --query 'InstanceRefreshes[0]'
```

### Subscribe to Notifications

```bash
# Subscribe to build notifications
aws sns subscribe \
  --topic-arn $(terraform output -raw sns_build_topic_arn) \
  --protocol email \
  --notification-endpoint your-email@example.com

# Subscribe to alerts
aws sns subscribe \
  --topic-arn $(terraform output -raw sns_alerts_topic_arn) \
  --protocol email \
  --notification-endpoint your-email@example.com
```

## Cost Optimization

### Development

- **Instance Type**: t3.micro (AWS free tier eligible)
- **Auto-scaling**: Disabled
- **ALB**: Disabled (NLB or direct access for cost savings)
- **Compliance Scanning**: Disabled
- **Log Retention**: 7 days

### Staging

- **Instance Type**: t3.small
- **ASG Min/Max**: 2-10 instances
- **ALB**: Enabled with HTTPS
- **Compliance Scanning**: Enabled
- **Log Retention**: 30 days
- **Off-peak Scaling**: Disabled (constant capacity for testing)

### Production

- **Instance Type**: t3.medium/large (right-sized for workload)
- **ASG Min/Max**: 5-50 instances (scales to 500+)
- **ALB**: Enabled with TLS 1.2+, deletion protection
- **Compliance Scanning**: Mandatory
- **Log Retention**: 3 years (GDPR compliance)
- **Off-peak Scaling**: Enabled (scale down 10 PM - 6 AM UTC)

### Cost Monitoring

```bash
# Estimate infrastructure costs
infracost breakdown --path . --format table

# Set up cost alerts
# via AWS Budgets or third-party tools
```

## Monitoring & Troubleshooting

### CloudWatch Dashboards

- **Image Builder Dashboard**: Build status, duration, compliance
- **ASG/Instance Dashboard**: Instance count, health, refresh progress, launch time
- **Load Balancer Dashboard**: Request count, latency, error rate, target health
- **Cost Dashboard**: Estimated vs actual spending per environment

### Key CloudWatch Alarms

| Alarm | Threshold | Action |
|-------|-----------|--------|
| Build Failure | Any failure | SNS notification to ops team |
| Build Latency | >25 minutes | Warning via SNS |
| Refresh Failure | Any failure | SNS notification + manual review |
| Unhealthy Targets | >0 unhealthy | SNS alert |
| Instance Launch Failure | Any failure | SNS alert |
| Compliance Failure | Any CIS violation | Build blocked, SNS alert |

### Debugging

```bash
# View Image Builder logs
aws logs tail /aws/imagebuilder/ami-hardening-pipeline-<env>

# View ASG operations
aws logs tail /aws/autoscaling/ami-hardening-asg-<env>

# View instance application logs
aws logs tail /aws/applicationinstances/ami-hardening-<env>

# View VPC Flow Logs
aws logs tail /aws/vpc/flow-logs/ami-hardening-<env>

# SSH to instance (if needed for debugging)
INSTANCE_ID=i-1234567890abcdef0
aws ssm start-session --target $INSTANCE_ID --document-name AWS-StartInteractiveCommand
```

## Compliance & Security

### CIS Level 1 Compliance

All built images are validated against CIS Level 1 benchmarks before being marked as ready for deployment. Failed builds are blocked from the registry.

Hardening includes:
- SELinux enforcement
- Firewall (firewalld) enabled
- SSH hardening (no root login, key-based auth only)
- Audit logging (auditd) enabled
- Kernel hardening parameters
- PAM password quality enforcement

### GDPR Compliance

- **Data Residency**: All infrastructure in single AWS region (us-east-1)
- **Audit Logs**: 3-year retention in S3 Glacier
- **Log Anonymization**: Build logs pseudonymized for personally identifiable information
- **Right to Erasure**: Documented procedure to delete logs for specific individuals

### Encryption

- **Data at Rest**: AES-256 for S3, EBS, SNS
- **Data in Transit**: TLS 1.2+ for ALB, HTTPS for API calls
- **Terraform State**: Encrypted in S3 + DynamoDB locking

## Maintenance

### Regular Tasks

- **Weekly**: Review CloudWatch dashboards for anomalies
- **Monthly**: Run cost analysis and optimization review
- **Quarterly**: Review and update CIS hardening baseline
- **Annually**: Audit access logs, update encryption keys

### Updating Hardening Baselines

1. Update `iac/playbooks/cis-hardening.yml` with new hardening rules
2. Increment version in `aws_imagebuilder_component`
3. Trigger new image build
4. Validate in staging environment
5. Deploy to production after validation

### Scaling Considerations

- **Max ASG Size**: 500 instances (per architecture plan)
- **Refresh Duration**: ~1 hour for 500-instance fleet
- **Build Duration**: <30 minutes per SLO
- **Canary Phase**: 10-20% of fleet for validation

## Rollback Procedures

### Image Rollback

If a newly deployed image causes issues:

```bash
# Identify last good AMI
aws ec2 describe-images \
  --owners self \
  --query 'Images[?contains(Name, `ami-hardening`) && Name!=`<current-image>`].{Name: Name, ID: ImageId, Created: CreationDate}' \
  --sort-by CreationDate

# Revert launch template to previous image
# Update launch template with previous AMI ID
# Start new instance refresh
```

### Infrastructure Rollback

```bash
# Terraform rollback to previous state
terraform apply -var-file=terraform.tfvars.prod -var-file=rollback.tfvars

# Or revert specific resources
terraform destroy -target aws_autoscaling_group.main
# Review and reapply
terraform apply -var-file=terraform.tfvars.prod
```

## Support & Documentation

- **Architecture Plan**: See `specs/001-ami-hardening-pipeline/plan.md`
- **Infrastructure Spec**: See `specs/001-ami-hardening-pipeline/spec.md`
- **Task Breakdown**: See `specs/001-ami-hardening-pipeline/tasks.md`

## Next Steps

1. [ ] Deploy dev environment for testing
2. [ ] Validate image builds complete successfully
3. [ ] Test ASG canary deployment
4. [ ] Deploy staging environment
5. [ ] Load test staging configuration
6. [ ] Deploy production environment with approval gates
7. [ ] Configure alerting and monitoring dashboards
8. [ ] Document runbooks for operations team
9. [ ] Train team on emergency procedures
10. [ ] Schedule quarterly compliance audits
