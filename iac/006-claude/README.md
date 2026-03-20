# Multi-Region Disaster Recovery Infrastructure

Infrastructure-as-Code implementation for multi-region AWS infrastructure with fully automated bidirectional failover and failback.

**Repository**: /home/tuna/git-repos/pw-sdd-iac-claude-001/iac
**Architecture**: Terraform 1.14.x + AWS Provider 5.31.x
**Regions**: eu-central-1 (primary), eu-west-1 (secondary DR)

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Deployment](#deployment)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Operations](#operations)
- [Troubleshooting](#troubleshooting)

## Overview

This infrastructure implements a disaster recovery setup across two AWS European regions with:

- **Primary Region (eu-central-1)**: Active production infrastructure
  - RDS Aurora PostgreSQL (writable primary, 100GB auto-scaling storage)
  - Application Load Balancer (internet-facing, public subnets)
  - Auto Scaling Group (2-10 instances, cpu/memory-based scaling)
  - Network: VPC 10.10.0.0/16, multi-AZ subnets

- **Secondary Region (eu-west-1)**: Disaster recovery standby
  - RDS Aurora Global Database read replica (automatic promotion on failover)
  - Standby ALB (Route 53 monitors, ready for failover)
  - Minimal ASG (1 instance for cost optimization, scales on failover)
  - Identical network topology (10.10.0.0/16 CIDR blocks)

- **Cross-Region Services**:
  - VPC Peering (low-latency replication and communication)
  - Route 53 Health Checks (30-second detection, automatic failover)
  - S3 State Buckets with Cross-Region Replication (infrastructure disaster recovery)
  - RDS Global Database (< 5 second replication latency)

## Architecture

### Network Topology

Each region has identical CIDR block (10.10.0.0/16) with three subnet tiers:

```
VPC: 10.10.0.0/16
├── Public Subnets (ALB tier): 10.10.1.0/24, 10.10.2.0/24
│   ├── Internet Gateway
│   └── NAT Gateway (per AZ)
├── Private App Subnets: 10.10.11.0/24, 10.10.12.0/24
│   ├── Application instances (t3.medium)
│   └── Auto Scaling Group
└── Private DB Subnets: 10.10.21.0/24, 10.10.22.0/24
    └── RDS Aurora cluster (db.t3.small)
```

### Security Model

- **Public Subnets**: ALB only, inbound HTTP/HTTPS, outbound to app tier
- **Private App Subnets**: Application instances, inbound from ALB + cross-region CIDR, outbound to DB + NAT
- **Private DB Subnets**: RDS only, inbound from app tier on port 5432
- **Encryption**: TLS 1.2+ in transit, AES-256 at rest (database, storage, state)

### Failover Flow

1. **Detection** (30 seconds): Route 53 health checks detect primary region failure
2. **Promotion** (< 30 minutes): RDS reads replica automatically promoted to writable primary
3. **Routing** (instant): Route 53 redirects traffic to secondary ALB
4. **Scale-Up** (5 minutes): Secondary ASG auto-scales from 1 to 10 instances

## Prerequisites

### Required

- AWS Account with appropriate IAM permissions
- Terraform >= 1.14.0
- AWS CLI v2 configured with credentials
- Git (for version control)

### AWS Account Setup

Before deploying, you must:

1. **Create S3 buckets for Terraform state** (BEFORE terraform init):
   ```bash
   aws s3api create-bucket \
     --bucket terraform-state-primary-{ACCOUNT_ID} \
     --region eu-central-1 \
     --create-bucket-configuration LocationConstraint=eu-central-1

   aws s3api create-bucket \
     --bucket terraform-state-secondary-{ACCOUNT_ID} \
     --region eu-west-1 \
     --create-bucket-configuration LocationConstraint=eu-west-1
   ```

2. **Enable versioning and encryption on state buckets**:
   ```bash
   aws s3api put-bucket-versioning \
     --bucket terraform-state-primary-{ACCOUNT_ID} \
     --versioning-configuration Status=Enabled

   aws s3api put-bucket-encryption \
     --bucket terraform-state-primary-{ACCOUNT_ID} \
     --server-side-encryption-configuration '{...}'  # See AWS docs
   ```

3. **Create DynamoDB lock tables** (OPTIONAL - for concurrent access protection):
   ```bash
   aws dynamodb create-table \
     --table-name terraform-locks-primary \
     --region eu-central-1 \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --billing-mode PAY_PER_REQUEST
   ```

4. **Update bucket names** in backend.tf files:
   - Replace `{account-id}` with your actual AWS account ID (e.g., 123456789012)

## Deployment

### Step 1: Deploy Primary Region

```bash
cd iac/primary

# Initialize backend and download providers/modules
terraform init

# Review planned changes
terraform plan -var-file=terraform.tfvars -out=primary.tfplan

# Apply changes to AWS
terraform apply primary.tfplan

# Note the outputs (ALB DNS, RDS endpoint, etc.)
terraform output
```

**Expected Resources**: VPC, subnets, security groups, ALB, RDS Aurora primary, ASG, IAM roles

**Estimated Time**: 15-20 minutes

**Cost**: ~$500-800/month (depending on traffic and RDS usage)

### Step 2: Deploy Secondary Region

```bash
cd ../secondary

# Initialize backend and download providers/modules
terraform init

# Review planned changes
terraform plan -var-file=terraform.tfvars -out=secondary.tfplan

# Apply changes to AWS
terraform apply secondary.tfplan

# Note the outputs for monitoring
terraform output
```

**Expected Resources**: Identical to primary, but with RDS read replica and reduced ASG size

**Estimated Time**: 15-20 minutes

**Cost**: ~$200-400/month (secondary is standby with reduced instances)

### Step 3: Configure Route 53 Failover

After both regions are deployed:

```bash
cd ../primary

# Create Route 53 hosted zone and failover routing
# (This requires a domain name - see docs/FAILOVER.md)
```

### Step 4: Validate Setup

```bash
# From primary region iac/ directory:

# Check primary region health
terraform output -raw alb_dns_name
# Test: curl http://{ALB_DNS}/health

# Check secondary region health
cd secondary
terraform output -raw alb_dns_name

# Verify RDS replication lag
aws rds describe-db-clusters \
  --region eu-central-1 \
  --db-cluster-identifier multi-region-dr-primary-aurora-cluster

# Verify VPC peering status
aws ec2 describe-vpc-peering-connections \
  --region eu-central-1 \
  --filters "Name=status-code,Values=active"
```

## Project Structure

```
iac/
├── primary/                           # Primary region (eu-central-1) infrastructure
│   ├── backend.tf                    # S3 + DynamoDB state backend
│   ├── provider.tf                   # AWS provider configuration
│   ├── versions.tf                   # Terraform/provider version constraints
│   ├── variables.tf                  # Input variable declarations
│   ├── outputs.tf                    # Output values
│   ├── locals.tf                     # Local values (naming, tags)
│   ├── terraform.tfvars              # Primary region variable values
│   │
│   ├── vpc.tf                        # VPC, subnets, IGW, NAT, routing
│   ├── security-groups.tf            # ALB, app, database security groups
│   ├── iam.tf                        # IAM roles and policies
│   ├── vpc-peering.tf                # VPC peering connection
│   ├── route53.tf                    # Route 53 health checks and DNS
│   ├── rds.tf                        # RDS Aurora primary database
│   ├── alb.tf                        # Application Load Balancer
│   ├── asg.tf                        # Auto Scaling Group
│   ├── storage.tf                    # S3 state buckets, DynamoDB locks
│   ├── secrets.tf                    # AWS Secrets Manager
│   ├── monitoring.tf                 # CloudWatch, CloudTrail, Config
│   ├── failover.tf                   # Failover detection and alerting
│   └── vpc-endpoints.tf              # VPC endpoints for AWS services
│
├── secondary/                         # Secondary region (eu-west-1) infrastructure
│   ├── [identical structure to primary]
│   ├── terraform.tfvars              # Secondary region variable values (asg_min_size=1)
│   └── [backend/provider point to eu-west-1]
│
├── modules/                          # Reusable Terraform modules
│   ├── vpc_module/
│   ├── rds_aurora_module/
│   ├── alb_module/
│   └── asg_module/
│
├── test/                             # Infrastructure tests
│   ├── primary_test.go               # Terratest for primary region
│   └── secondary_test.go             # Terratest for secondary region
│
├── docs/                             # Operational documentation
│   ├── ARCHITECTURE.md               # Detailed architecture design
│   ├── FAILOVER.md                   # Failover procedures
│   ├── FAILBACK.md                   # Failback procedures
│   └── TROUBLESHOOTING.md            # Common issues and diagnostics
│
└── README.md                         # This file
```

## Configuration

### Environment Variables

Set AWS credentials before deployment:

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="eu-central-1"
```

Or use AWS CLI configuration:

```bash
aws configure
```

### Terraform Variables

Each region has its own `terraform.tfvars`:

**Primary Region** (`primary/terraform.tfvars`):
- `aws_region`: "eu-central-1"
- `environment`: "primary"
- `asg_min_size`: 2 (active)
- `asg_max_size`: 10

**Secondary Region** (`secondary/terraform.tfvars`):
- `aws_region`: "eu-west-1"
- `environment`: "secondary"
- `asg_min_size`: 1 (standby, cost-optimized)
- `asg_max_size`: 10 (scales up on failover)

### Key Configuration Values

| Component | Primary | Secondary | Notes |
|-----------|---------|-----------|-------|
| Region | eu-central-1 | eu-west-1 | Both in EU for data residency |
| VPC CIDR | 10.10.0.0/16 | 10.10.0.0/16 | IDENTICAL for seamless failover |
| RDS Instance | db.t3.small (writable) | db.t3.small (read-only) | Auto-promote on failover |
| Instances | 2-10 (active) | 1-10 (standby) | Secondary scales up on failure |
| ALB | Active | Standby | Route 53 controls traffic |
| Replication | N/A | < 5 second latency | Aurora Global Database |

## Operations

### Monitoring

**Application Health**: Route 53 health checks (HTTP /health endpoint)
**Database Replication**: CloudWatch metrics on RDS Global Database lag
**Instance Scaling**: CloudWatch alarms on CPU/memory utilization
**Costs**: AWS Cost Explorer, Infracost estimates

### Scaling

Manual scaling of ASG:

```bash
aws autoscaling set-desired-capacity \
  --region eu-central-1 \
  --auto-scaling-group-name multi-region-dr-primary-asg \
  --desired-capacity 4
```

### Updates

To update infrastructure:

1. Edit variable values in `terraform.tfvars`
2. Run `terraform plan` to review changes
3. Run `terraform apply` to deploy changes
4. Repeat for secondary region if needed

### Destruction

**WARNING**: This permanently deletes all resources!

```bash
cd iac/primary
terraform destroy -var-file=terraform.tfvars -auto-approve

cd ../secondary
terraform destroy -var-file=terraform.tfvars -auto-approve
```

## Troubleshooting

See `docs/TROUBLESHOOTING.md` for common issues:

- **Health check failures**: Verify ALB target group registration
- **Replication lag**: Check network connectivity and RDS parameter groups
- **Route 53 failover not working**: Verify health check configuration
- **Cost overages**: Review ASG scaling policies and instance types

## Next Steps

1. **Deploy Infrastructure**: Follow [Deployment](#deployment) section
2. **Test Failover**: See `docs/FAILOVER.md` for manual failover testing
3. **Configure Monitoring**: Set up CloudWatch alarms and dashboards
4. **Document**: Add application-specific configurations (security groups, instance sizes)
5. **Automate**: Integrate with CI/CD pipeline for automated deployments

## Support

For issues or questions:
- Review `docs/TROUBLESHOOTING.md`
- Check AWS console for resource status and logs
- Inspect Terraform state: `terraform show`
- Review CloudWatch logs: `/aws/ec2/multi-region-dr-*/application-instances`

---

**Last Updated**: 2026-03-20
**Terraform Version**: >= 1.14.0
**AWS Provider**: >= 5.30.0
**Infrastructure**: Multi-Region Disaster Recovery (EU)
