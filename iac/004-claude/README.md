# Customer Orders Database Infrastructure

Terraform infrastructure for deploying a reliable, scalable PostgreSQL database to store customer orders and contact information.

## Quick Start

### Prerequisites

- Terraform >= 1.14.0
- AWS CLI configured with credentials (or AWS_PROFILE environment variable)
- PostgreSQL client (psql) for database administration (optional)
- Infracost (for cost estimation)

### Initial Setup (Development)

```bash
# Navigate to infrastructure directory
cd iac/

# Initialize Terraform (local state for development)
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt

# Preview changes for development environment
terraform plan -var-file=terraform.tfvars.dev

# Deploy development infrastructure
terraform apply -var-file=terraform.tfvars.dev
```

### Multi-Environment Setup (Staging/Production)

#### Step 1: Create S3 and DynamoDB for Remote State

```bash
# Create S3 bucket for staging state
aws s3api create-bucket \
  --bucket myproject-terraform-state-staging \
  --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket myproject-terraform-state-staging \
  --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking (staging)
aws dynamodb create-table \
  --table-name terraform-lock-staging \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region us-east-1

# Repeat for production
aws s3api create-bucket \
  --bucket myproject-terraform-state-prod \
  --region us-east-1

aws s3api put-bucket-versioning \
  --bucket myproject-terraform-state-prod \
  --versioning-configuration Status=Enabled

aws dynamodb create-table \
  --table-name terraform-lock-prod \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region us-east-1
```

#### Step 2: Initialize Terraform Workspaces

```bash
# Initialize Terraform with S3 backend for staging
terraform init \
  -backend-config="bucket=myproject-terraform-state-staging" \
  -backend-config="key=terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="dynamodb_table=terraform-lock-staging" \
  -backend-config="encrypt=true"

# Create workspaces
terraform workspace new staging
terraform workspace new prod

# Verify workspaces
terraform workspace list
```

#### Step 3: Deploy by Environment

```bash
# Development (local state, already initialized)
terraform workspace select default
terraform plan -var-file=terraform.tfvars.dev
terraform apply -var-file=terraform.tfvars.dev

# Staging
terraform workspace select staging
terraform init \
  -backend-config="bucket=myproject-terraform-state-staging" \
  -backend-config="key=terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="dynamodb_table=terraform-lock-staging" \
  -backend-config="encrypt=true" \
  -reconfigure
terraform plan -var-file=terraform.tfvars.staging
terraform apply -var-file=terraform.tfvars.staging

# Production (requires extra safeguards)
terraform workspace select prod
terraform init \
  -backend-config="bucket=myproject-terraform-state-prod" \
  -backend-config="key=terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="dynamodb_table=terraform-lock-prod" \
  -backend-config="encrypt=true" \
  -reconfigure
terraform plan -var-file=terraform.tfvars.prod

# IMPORTANT: Review plan output carefully before applying to production
# Ensure multi-AZ and deletion protection are enabled
terraform apply -var-file=terraform.tfvars.prod
```

## Architecture

### Network

- **VPC**: 10.0.0.0/16 in us-east-1
- **Database Subnets**: 
  - Primary: 10.0.10.0/24 (us-east-1a)
  - Secondary: 10.0.11.0/24 (us-east-1b) for Multi-AZ failover
- **Security**: RDS restricted to internal VPC access only

### Database

- **Engine**: PostgreSQL 15.x
- **Instance Types**:
  - Development: db.t3.micro (AWS free tier eligible)
  - Staging: db.t3.small (Multi-AZ failover testing)
  - Production: db.t3.small or larger (Multi-AZ active-passive)
- **Storage**: 20-100GB with auto-scaling
- **Backups**:
  - Development: 7-day retention
  - Staging: 30-day retention
  - Production: 90-day retention
- **Monitoring**: Enhanced monitoring to CloudWatch, audit logging enabled

### Security

- Encryption at rest (AWS-managed keys, can upgrade to customer-managed for production)
- Encryption in transit (TLS 1.2+)
- Database credentials stored in AWS Secrets Manager with automatic rotation (90 days for production)
- Application access via IAM roles (least privilege)
- RDS Proxy (optional for production) for connection pooling

### Monitoring & Alerts

- CloudWatch alarms for:
  - Database availability
  - CPU utilization
  - Storage space
  - Database connections
  - Query latency
- SNS notifications for critical events
- Enhanced RDS monitoring at 60-second intervals
- PostgreSQL audit logging enabled

## Getting Database Connection Details

After deployment, retrieve connection details from Terraform outputs:

```bash
# Get RDS endpoint
terraform output rds_endpoint

# Get database credentials from Secrets Manager
aws secretsmanager get-secret-value \
  --secret-id orders-db-password-dev \
  --query SecretString \
  --output text | jq

# Connection string template
terraform output connection_string_template
```

### Example: Connecting to Database

```bash
# Using psql
psql -h $(terraform output -raw rds_address) \
     -U postgres \
     -d orders_db

# Application connection (from environment variable)
export DATABASE_URL="postgresql://postgres:${PASSWORD}@$(terraform output -raw rds_address):5432/orders_db"
```

## Database Schema

### Tables

**customers**
- id: UUID primary key
- email: unique email address
- contact_info: JSONB for flexible contact details

**orders**
- id: UUID primary key
- customer_id: foreign key to customers
- order_date: timestamp
- total_amount: decimal
- status: enum (pending, confirmed, shipped, delivered, cancelled)

**audit_log**
- id: UUID primary key
- table_name: name of modified table
- operation: INSERT, UPDATE, or DELETE
- changed_data: JSONB of changed values
- timestamp: when change occurred

## Common Operations

### Backup and Restore

```bash
# Create manual snapshot
aws rds create-db-snapshot \
  --db-instance-identifier $(terraform output -raw rds_instance_id) \
  --db-snapshot-identifier orders-manual-snapshot-$(date +%Y%m%d-%H%M%S)

# List snapshots
aws rds describe-db-snapshots \
  --filters "Name=db-instance-id,Values=$(terraform output -raw rds_instance_id)"

# Restore from snapshot
aws rds restore-db-instance-from-db-snapshot \
  --db-instance-identifier orders-restored-$(date +%Y%m%d-%H%M%S) \
  --db-snapshot-identifier orders-manual-snapshot-20260402-143000
```

### Scaling

```bash
# Scale up instance type (staging/prod)
terraform apply -var-file=terraform.tfvars.prod \
  -var="instance_type=db.t3.medium"

# Scale up storage
terraform apply -var-file=terraform.tfvars.prod \
  -var="storage_size=50"
```

### Monitoring

```bash
# View CloudWatch metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/RDS \
  --metric-name CPUUtilization \
  --dimensions Name=DBInstanceIdentifier,Value=$(terraform output -raw rds_instance_id) \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 300 \
  --statistics Average

# View RDS logs
aws logs tail /aws/rds/instance/$(terraform output -raw rds_instance_id)/postgresql --follow
```

## Troubleshooting

### Connection Issues

**Problem**: Cannot connect to RDS from application

**Solutions**:
1. Verify security group allows inbound traffic on port 5432
2. Check application is using correct endpoint, port, and credentials
3. Verify application IAM role has Secrets Manager read access
4. Ensure application is in same VPC or has network route to database

### Performance Issues

**Problem**: Slow queries or high latency

**Solutions**:
1. Check CloudWatch metrics for CPU, memory, storage
2. Review PostgreSQL audit logs for slow queries
3. Create indexes on frequently queried columns
4. Scale up instance type if baseline is exceeded
5. Check for lock contention with `pg_locks` view

### Backup Failures

**Problem**: Automated backups failing

**Solutions**:
1. Verify RDS Enhanced Monitoring IAM role exists and has permissions
2. Check backup window doesn't overlap with maintenance window
3. Verify sufficient storage available for snapshots
4. Review RDS events in CloudWatch Events

## Cost Estimation

Use Infracost to estimate monthly costs:

```bash
# Install Infracost
brew install infracost

# Estimate costs for development
infracost breakdown --path . -var-file=terraform.tfvars.dev

# Estimate costs for all environments
for env in dev staging prod; do
  echo "=== $env ==="
  infracost breakdown --path . -var-file=terraform.tfvars.$env
done
```

**Expected Monthly Costs**:
- Development: ~$30-50 (free tier eligible)
- Staging: ~$100-150 (Multi-AZ + t3.small)
- Production: ~$150-250 (Multi-AZ + t3.small + RDS Proxy + enhanced monitoring)

## Security Best Practices

1. **Always use remote state** for staging/production (S3 + DynamoDB)
2. **Enable MFA** on AWS account before managing production infrastructure
3. **Rotate database passwords** regularly (automated every 90 days in production)
4. **Review database access logs** monthly for security audits
5. **Test backup/restore procedures** quarterly to ensure RTO/RPO targets
6. **Use least privilege IAM roles** for application access
7. **Enable encryption** for all environments
8. **Monitor CloudWatch alarms** continuously for anomalies
9. **Tag all resources** for cost tracking and governance
10. **Update PostgreSQL regularly** to latest patch version

## Maintenance Windows

- **Backup Window**: 02:00-03:00 UTC (before business hours)
- **Maintenance Window**: Sun 03:00-04:00 UTC (minimal user impact)
- **Secrets Rotation**: Every 90 days (production only)

## Support

For issues or questions:
1. Check Terraform state: `terraform show`
2. Review RDS events: `aws rds describe-events --source-type db-instance`
3. Check CloudWatch logs: `aws logs tail /aws/rds/instance/...`
4. Review infrastructure plan: `terraform plan`

## License

This infrastructure code is part of the Customer Orders Database project.
