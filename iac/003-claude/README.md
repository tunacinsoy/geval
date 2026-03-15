# Temporary Feature Testing Playground - Infrastructure as Code

**Specification**: [spec.md](../specs/003-test-playground/spec.md)
**Architecture Plan**: [plan.md](../specs/003-test-playground/plan.md)
**Implementation Tasks**: [tasks.md](../specs/003-test-playground/tasks.md)

---

## Overview

This Terraform configuration provisions a temporary, cost-optimized AWS testing infrastructure for 2-3 week feature validation sprints. The infrastructure includes:

- **VPC**: Single-zone network with public/private subnets (10.0.0.0/16)
- **Compute**: EC2 instances (t3.micro, 1-5 configurable)
- **Database**: RDS PostgreSQL 15.x with automatic failover replica
- **Storage**: S3 bucket for test artifacts
- **Monitoring**: CloudWatch Logs and metrics

**Budget**: $150-300 for 2-3 weeks | **Monthly Rate**: < $500 if extended
**Security**: Encryption at rest/transit, network isolation, IAM least privilege
**Cost Optimization**: Single-zone, minimal instance types, no backups, auto-cleanup

---

## Prerequisites

### Required

- **AWS Account**: Active AWS account with appropriate permissions
- **Terraform Cloud**: Free tier account and API token ([sign up](https://app.terraform.io/signup))
- **Terraform CLI**: Version >= 1.14.0 ([install](https://www.terraform.io/downloads))
- **AWS CLI**: Version 2.x ([install](https://aws.amazon.com/cli/))
- **Credentials**: AWS credentials configured locally
  ```bash
  aws configure
  # Enter: Access Key ID, Secret Access Key, Default Region, Output Format
  ```

### Recommended

- **PostgreSQL Client**: `psql` for database testing
  ```bash
  # macOS
  brew install postgresql@15

  # Ubuntu/Debian
  sudo apt-get install postgresql-client
  ```

- **AWS Console Access**: Verify you can log into [AWS Console](https://console.aws.amazon.com)

---

## Quick Start (5 minutes)

### 1. Clone and Setup

```bash
# Clone repository and navigate to IaC directory
git clone <repo-url>
cd <repo>/iac

# Set Terraform Cloud organization (update with your org)
# Edit terraform.tfvars: organization = "your-org"
```

### 2. Configure Credentials

```bash
# Set RDS password as environment variable (required)
export TF_VAR_db_master_password="YourSecurePassword123!"

# Terraform Cloud token (if using Terraform Cloud backend)
export TF_CLOUD_TOKEN="YOUR_TERRAFORM_CLOUD_API_TOKEN"
```

### 3. Initialize and Plan

```bash
# Initialize Terraform and download providers
terraform init

# Review planned changes
terraform plan -var-file=terraform.tfvars

# Check estimated costs
infracost breakdown --path .
```

### 4. Deploy

```bash
# Apply configuration (provisions all resources)
terraform apply -var-file=terraform.tfvars

# Save outputs (important for team onboarding)
terraform output > infrastructure-outputs.json
```

### 5. Verify Deployment

```bash
# Test RDS connection
psql -h <rds_endpoint> -U testadmin -d testdb

# Test S3 access
aws s3 ls <s3_bucket_name>

# Connect to EC2 instance
aws ssm start-session --target <instance_id> --region us-east-1
```

---

## Configuration

### terraform.tfvars

Edit `terraform.tfvars` to customize infrastructure:

```hcl
# Region (default: us-east-1)
aws_region = "us-east-1"

# VPC CIDR (default: 10.0.0.0/16)
vpc_cidr_block = "10.0.0.0/16"

# EC2 Instance Configuration
instance_count = 2                    # 1-5 instances
instance_type  = "t3.micro"           # Minimal cost
rds_instance_class = "db.t3.micro"    # Minimal cost
db_allocated_storage = 20              # GB

# Environment
environment  = "test"
project_name = "feature-testing"

# Optional: Load balancer (adds ~$0.25/day)
# enable_alb = true

# Optional: Auto-shutdown (saves cost during off-hours)
# enable_autoshutdown = true
# autoshutdown_time = "22:00"
```

### Sensitive Variables

**NEVER commit sensitive values to Git**:

```bash
# Set RDS password via environment variable
export TF_VAR_db_master_password="YourPassword"

# Alternative: Create terraform.tfvars.secret (in .gitignore)
# db_master_password = "YourPassword"
```

---

## Deployment Steps

### Full Deployment Workflow

```bash
# 1. Initialize Terraform
cd iac/
terraform init

# 2. Validate configuration
terraform validate
terraform fmt -check

# 3. Preview changes
terraform plan -var-file=terraform.tfvars

# 4. Apply infrastructure
terraform apply -var-file=terraform.tfvars

# 5. Save connection information
terraform output > outputs.json

# 6. Verify infrastructure
# Run verification commands from "Verification" section below
```

### Incremental Changes

```bash
# To modify number of instances (1-5)
# Edit terraform.tfvars: instance_count = 3
terraform apply

# To modify database storage
# Edit terraform.tfvars: db_allocated_storage = 30
terraform apply

# To enable ALB (additional cost)
# Edit terraform.tfvars: enable_alb = true
terraform apply
```

---

## Architecture

### Infrastructure Topology

```
Internet
    |
    v
┌──────────────────────────────────┐
│      Public Subnet (10.0.1.0/24) │
│  ┌────────────────────────────┐  │
│  │ NAT Gateway + Elastic IP   │  │
│  │ Internet Gateway           │  │
│  └────────────────────────────┘  │
└──────────────────────────────────┘
         |
         v
┌──────────────────────────────────────────┐
│   Private Subnet (10.0.10.0/24)          │
│  ┌──────────────────────────────────┐   │
│  │  EC2 Instances (1-5 t3.micro)    │   │
│  │  - CloudWatch Agent              │   │
│  │  - Docker                        │   │
│  │  - IAM Role (S3, Logs access)    │   │
│  └──────────────────────────────────┘   │
│                                          │
│  ┌──────────────────────────────────┐   │
│  │  RDS PostgreSQL 15.x             │   │
│  │  - Primary + Standby Replica     │   │
│  │  - Encryption at rest + TLS      │   │
│  │  - 20GB Storage (adjustable)     │   │
│  └──────────────────────────────────┘   │
└──────────────────────────────────────────┘

S3 Bucket: Private, encrypted, no versioning
CloudWatch: App, System, Docker, RDS logs (7-day retention)
```

### Security Model

| Layer | Control | Details |
|-------|---------|---------|
| **Network** | VPC Isolation | Public/Private subnets, NAT for outbound only |
| **Compute** | Security Groups | EC2 ingress 22/80/443; Egress to all; RDS ingress from EC2 only |
| **Data** | Encryption | RDS: AES-256 + TLS 1.2+ | S3: AES-256 (no KMS) |
| **Access** | IAM Roles | EC2 instance: S3 read/write, CloudWatch Logs write |
| **Admin** | Terraform Cloud | Remote state with encryption and access control |

---

## Team Access & Onboarding

### Terraform Cloud Setup

```bash
# 1. Create organization in Terraform Cloud
# https://app.terraform.io/app/organizations

# 2. Generate API token
# Settings → Tokens → Create API Token

# 3. Share token with team securely
# Store in 1Password or similar (NEVER in Git/email)

# 4. Team members authenticate
export TF_CLOUD_TOKEN="YOUR_TOKEN"

# 5. Run terraform commands
terraform init  # Authenticates with Terraform Cloud workspace
```

### AWS Console Access

```bash
# Grant team members AWS account access
# 1. Go to AWS IAM Console
# 2. Create group or use existing development group
# 3. Add policy: AmazonEC2FullAccess + AmazonRDSFullAccess + S3FullAccess
# 4. Add team members to group
```

### Connection Information

Save these outputs after `terraform apply` and share securely:

```bash
# RDS Database
Host: <rds_endpoint>
Port: 5432
Database: testdb
Username: testadmin
Password: <from environment variable>

# S3 Bucket
Bucket: <s3_bucket_name>
Region: us-east-1

# EC2 Instances
Instance IDs: <instance_ids>
Private IPs: <instance_ips>
Security Group: <security_group_id>

# CloudWatch Logs
App: /test-playground/app
RDS: /test-playground/rds
System: /test-playground/system
Docker: /test-playground/docker
```

---

## Accessing Infrastructure

### Database Connection

```bash
# Test connection
psql -h <rds_endpoint> -U testadmin -d testdb -c "SELECT version();"

# Connection in application code
PGHOST=<rds_endpoint>
PGPORT=5432
PGDATABASE=testdb
PGUSER=testadmin
PGPASSWORD=<password>
```

### EC2 Instances

```bash
# Option 1: SSM Session Manager (recommended, no SSH keys needed)
aws ssm start-session --target <instance_id> --region us-east-1

# Option 2: SSH (requires security group rule allowing your IP)
# Requires key pair in launch template (not configured by default)
ssh -i key.pem ec2-user@<instance_ip>
```

### S3 Bucket

```bash
# List contents
aws s3 ls s3://<bucket_name>/

# Upload file
aws s3 cp myfile.txt s3://<bucket_name>/

# Download file
aws s3 cp s3://<bucket_name>/myfile.txt .

# Mount in EC2 (via CloudWatch agent or application)
# See user_data.sh for agent configuration
```

### CloudWatch Logs

```bash
# View logs locally
aws logs tail /test-playground/app --follow
aws logs tail /test-playground/system --follow
aws logs tail /test-playground/docker --follow

# Or use AWS Console
# https://console.aws.amazon.com/cloudwatch/home#logStream:
```

---

## RDS Failover (Testing)

### Test Automatic Failover

```bash
# 1. Note current endpoint
terraform output rds_endpoint

# 2. Reboot RDS primary instance (forces failover to replica)
aws rds reboot-db-instance \
  --db-instance-identifier test-feature-testing-postgres \
  --force-failover \
  --region us-east-1

# 3. Monitor failover (2-3 minutes)
aws rds describe-db-instances \
  --db-instance-identifier test-feature-testing-postgres \
  --query 'DBInstances[0].DBInstanceStatus' \
  --region us-east-1

# 4. Verify connectivity after failover
psql -h <new_rds_endpoint> -U testadmin -d testdb -c "SELECT version();"

# 5. Replica becomes new primary; restore primary as replica
# (Automatic in RDS with Multi-AZ - manual in our single-AZ setup)
```

---

## Cost Tracking

### Estimate Costs

```bash
# Before deployment
infracost breakdown --path . --format markdown

# Example breakdown (2-3 weeks):
# EC2 t3.micro × 2: ~$7
# RDS t3.micro: ~$15
# NAT Gateway: ~$15
# S3: ~$0 (minimal)
# Total: ~$37 per week = $150 for 4 weeks
```

### Monitor Costs

```bash
# AWS Console Cost Explorer
# https://console.aws.amazon.com/cost-management/home#/custom

# CLI
aws ce get-cost-and-usage \
  --time-period Start=2026-03-15,End=2026-04-15 \
  --granularity DAILY \
  --metrics BlendedCost \
  --group-by Type=TAG,Key=Project
```

### Cost Optimization

- Use smallest instance types (t3.micro)
- Single-zone (no multi-AZ premium)
- Minimal storage (20GB)
- Disable detailed monitoring
- Auto-shutdown during off-hours (optional)
- No backup retention (data discarded)

---

## Cleanup & Teardown

### Deprovisioning Procedure

```bash
# 1. Export final outputs (if needed)
terraform output > final-outputs.json

# 2. Backup any test data from S3/RDS
aws s3 sync s3://<bucket_name> ./backup/

# 3. Preview destruction
terraform plan -destroy

# 4. Destroy all resources (IRREVERSIBLE)
terraform destroy

# 5. Verify cleanup
# AWS Console → EC2, RDS, S3 → Confirm all resources deleted

# 6. Delete Terraform Cloud workspace
# https://app.terraform.io → Workspace Settings → Delete Workspace
```

### Automated Cleanup

Optional: Schedule automatic teardown after 2-3 weeks:

```bash
# Create Lambda function to run terraform destroy on schedule
# (Not implemented by default - add as needed)
```

---

## Troubleshooting

### Common Issues

#### 1. Terraform Init Fails

```bash
# Problem: Backend not found
# Solution: Update terraform.tfvars with correct Terraform Cloud org

# Problem: Provider download fails
# Solution: Check internet connection and firewall rules
# Try: terraform init -upgrade
```

#### 2. RDS Connection Fails

```bash
# Problem: "Connection timed out"
# Solution:
#   - Verify RDS endpoint is in private subnet
#   - Check EC2 NAT Gateway is configured
#   - Test from EC2 instance (not local)
#   - psql -h <rds_endpoint> -U testadmin -d testdb

# Problem: "Authentication failed"
# Solution: Verify RDS password set via TF_VAR_db_master_password
export TF_VAR_db_master_password="<password>"
terraform apply
```

#### 3. EC2 Instance Unresponsive

```bash
# Problem: Cannot SSH or connect via SSM
# Solution:
#   - Reboot instance: aws ec2 reboot-instances --instance-ids <id>
#   - Check security group rules
#   - Verify EC2 is in private subnet with NAT for outbound
#   - Use SSM Session Manager if SSH unavailable

aws ssm start-session --target <instance_id>
```

#### 4. S3 Bucket Not Accessible from EC2

```bash
# Problem: EC2 instance cannot write to S3
# Solution:
#   - Verify IAM role policy attached to instance
#   - Test: aws s3 ls from EC2 instance
#   - Check bucket policy allows EC2 role
#   - Verify instance has outbound internet (NAT)
```

#### 5. High Costs

```bash
# Problem: Monthly costs exceed $500
# Solution:
#   - Reduce instance_count (T1-5)
#   - Disable ALB if enabled
#   - Disable detailed CloudWatch monitoring
#   - Enable auto-shutdown during off-hours
#   - Use infracost to identify expensive resources
```

### Debug Commands

```bash
# View Terraform state
terraform show

# View specific resource
terraform state show aws_db_instance.main

# Get outputs
terraform output

# Enable debug logging
export TF_LOG=DEBUG
terraform apply

# Validate configuration syntax
terraform validate
terraform fmt -check
```

---

## Security Best Practices

1. **Secrets Management**
   - Never commit `terraform.tfvars` with passwords
   - Use environment variables: `export TF_VAR_db_master_password="..."`
   - Store in 1Password, AWS Secrets Manager, or similar

2. **SSH Access**
   - Use SSM Session Manager (no SSH keys)
   - If SSH needed: Add `key_name` to launch template

3. **Network Security**
   - EC2 instances have no public IP (private subnet)
   - RDS accessible only from EC2
   - All data encrypted in transit (TLS)

4. **IAM Least Privilege**
   - EC2 role: S3, Logs, RDS read-only
   - Terraform Cloud: Workspace-level permissions
   - AWS Account: Restrict to specific team members

5. **Code Reviews**
   - Review all `terraform plan` before apply
   - Use Terraform Cloud for policy as code
   - Enable branch protection on main

---

## Additional Resources

- **Terraform Documentation**: https://www.terraform.io/docs
- **AWS Terraform Provider**: https://registry.terraform.io/providers/hashicorp/aws/latest
- **Terraform Cloud**: https://app.terraform.io
- **AWS CLI Reference**: https://docs.aws.amazon.com/cli/latest/
- **RDS PostgreSQL**: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html
- **EC2 Instance Types**: https://aws.amazon.com/ec2/instance-types/
- **CloudWatch Logs**: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/

---

## Support & Questions

For issues or questions:

1. Check CloudWatch Logs: `/test-playground/*`
2. Review AWS Console for resource status
3. Run `terraform plan` to verify configuration
4. Check Terraform Cloud for state history
5. Refer to troubleshooting section above

---

## Version History

| Date | Version | Changes |
|------|---------|---------|
| 2026-03-15 | 1.0 | Initial infrastructure implementation |

---

**Last Updated**: 2026-03-15
**Expiration**: 2026-04-15 (manual reminder for cleanup)
