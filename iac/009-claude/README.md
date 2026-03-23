# Hybrid DNS Resolver Infrastructure

Infrastructure-as-Code for Route 53 Resolver with inbound/outbound endpoints for hybrid cloud DNS resolution.

## Overview

This Terraform configuration implements a highly available hybrid DNS resolver infrastructure that enables seamless DNS resolution between cloud (AWS) and on-premises networks. The resolver is distributed across two availability zones for automatic failover and provides:

- **Inbound Endpoint**: Receives DNS queries from on-premises network for cloud-hosted services
- **Outbound Endpoint**: Forwards queries for on-premises domains (corp.internal) to on-premises DNS servers
- **Active-Active Load Balancing**: Both on-premises DNS servers (192.168.10.5, 192.168.10.6) receive queries
- **Network Security**: Security groups restrict DNS traffic (port 53) to authorized networks only
- **CloudWatch Monitoring**: Query logging, metrics, dashboards, and alarming for operational visibility

## Prerequisites

Before deploying this infrastructure, ensure:

1. **AWS Account**: Access to an AWS account with appropriate IAM permissions
2. **Terraform**: Version >= 1.6.0 installed locally
3. **AWS CLI**: Configured with credentials for your AWS account
4. **Transit Gateway**: Existing Transit Gateway attachment between VPC and on-premises network
5. **On-Premises DNS**: DNS servers operational at 192.168.10.5 and 192.168.10.6
6. **S3 Backend**: S3 bucket and DynamoDB table created for Terraform state (see setup instructions)

### S3 Backend Setup (One-time)

Create the S3 bucket and DynamoDB table for Terraform state:

```bash
# Create S3 bucket for Terraform state
aws s3api create-bucket \
  --bucket terraform-state-009-hybrid-dns \
  --region us-east-1

# Enable versioning on the bucket
aws s3api put-bucket-versioning \
  --bucket terraform-state-009-hybrid-dns \
  --versioning-configuration Status=Enabled

# Enable encryption on the bucket
aws s3api put-bucket-encryption \
  --bucket terraform-state-009-hybrid-dns \
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
  --table-name terraform-state-lock-009-hybrid-dns \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

## Quick Start

### 1. Initialize Terraform

```bash
cd iac/
terraform init
```

### 2. Select Environment

Choose your target environment (dev, staging, or prod):

```bash
terraform workspace new dev    # Create dev workspace if not exists
terraform workspace select dev # Switch to dev workspace
```

### 3. Configure Variables

Update `terraform.tfvars.dev` with your environment-specific values:

```bash
# Edit the variable file with your Transit Gateway attachment ID
vim terraform.tfvars.dev
```

**Critical variables to set**:
- `transit_gateway_attachment_id`: ID of existing Transit Gateway attachment
- `on_premises_dns_servers`: IP addresses of your on-premises DNS servers (default: 192.168.10.5, 192.168.10.6)
- `on_premises_cidr`: CIDR block of your on-premises network (default: 192.168.0.0/16)

### 4. Preview Changes

Review what Terraform will create:

```bash
terraform plan -var-file=terraform.tfvars.dev
```

### 5. Deploy Infrastructure

Deploy the hybrid DNS resolver infrastructure:

```bash
terraform apply -var-file=terraform.tfvars.dev
```

**Note**: Terraform will ask for confirmation before making changes.

### 6. Verify Outputs

After successful deployment, Terraform displays important output values:

```bash
terraform output
```

Key outputs:
- `inbound_endpoint_ip`: Configure on-premises clients to use this IP for cloud service resolution
- `outbound_endpoint_id`: For monitoring and reference
- `cloudwatch_log_group_name`: Where DNS query logs are stored

## Environment Strategy

### Dev Environment
- **Log Retention**: 30 days (cost-optimized)
- **Use Case**: Testing DNS resolution, validation, learning
- **Workspace**: `dev`
- **Variable File**: `terraform.tfvars.dev`

### Staging Environment
- **Log Retention**: 60 days
- **Use Case**: Production-like validation, performance testing
- **Workspace**: `staging`
- **Variable File**: `terraform.tfvars.staging`

### Production Environment
- **Log Retention**: 90 days (compliance)
- **Use Case**: Production workloads, real DNS traffic
- **Workspace**: `prod`
- **Variable File**: `terraform.tfvars.prod`

### Switching Environments

```bash
# Switch workspace
terraform workspace select staging

# Deploy to staging
terraform apply -var-file=terraform.tfvars.staging
```

## File Structure

```
iac/
├── backend.tf                    # S3 + DynamoDB state backend
├── provider.tf                   # AWS provider configuration
├── versions.tf                   # Terraform and provider versions
├── variables.tf                  # Input variable declarations
├── vpc.tf                        # VPC, subnets, route tables
├── security-groups.tf            # Security groups for endpoints
├── iam.tf                        # IAM roles and policies
├── resolver.tf                   # Route 53 Resolver endpoints & rules
├── monitoring.tf                 # CloudWatch logs, metrics, alarms
├── outputs.tf                    # Output values
├── terraform.tfvars.dev          # Dev environment variables
├── terraform.tfvars.staging      # Staging environment variables
├── terraform.tfvars.prod         # Production environment variables
└── README.md                     # This file
```

## Monitoring

### CloudWatch Log Group

DNS query logs are stored in:
```
/aws/route53resolver/dns-queries-dev
/aws/route53resolver/dns-queries-staging
/aws/route53resolver/dns-queries-prod
```

### CloudWatch Dashboard

A dashboard is automatically created for monitoring:
- Total DNS queries
- SERVFAIL errors
- Timeout errors
- Query response codes

Access via AWS Console:
```
CloudWatch > Dashboards > hybrid-dns-resolver-{environment}
```

### CloudWatch Alarms

Alarms are configured to notify when:
- DNS error rate exceeds 1% (SERVFAIL + TIMEOUT)

Subscribe to notifications:
1. Check SNS topic: `hybrid-dns-resolver-alarms-{environment}`
2. Confirm subscription email
3. Receive alerts on DNS resolver issues

### Manual Testing

Test DNS resolution from cloud resources:

```bash
# From an EC2 instance in your VPC
nslookup workstation.corp.internal <inbound_endpoint_ip>
nslookup service.corp.internal <inbound_endpoint_ip>

# Expected output: Resolved IP addresses for on-premises services
```

## Troubleshooting

### DNS Queries Not Resolving

1. **Check Endpoint Health**:
   ```bash
   aws route53resolver describe-resolver-endpoints \
     --region us-east-1 | jq '.ResolverEndpoints[] | {Name,Status}'
   ```

2. **Verify Security Groups**:
   - Inbound endpoint: Allow UDP/TCP 53 from VPC CIDR and on-premises CIDR
   - Outbound endpoint: Allow UDP/TCP 53 to on-premises DNS servers

3. **Check Route Tables**:
   - Ensure route to on-premises CIDR points to Transit Gateway
   ```bash
   aws ec2 describe-route-tables --region us-east-1 | jq '.RouteTables[] | .Routes'
   ```

4. **Review CloudWatch Logs**:
   ```bash
   aws logs tail /aws/route53resolver/dns-queries-dev --follow
   ```

### High Latency

1. **Check Endpoint Status**:
   - Endpoints should have `Status: OPERATIONAL`
   - Health checks should pass

2. **On-Premises DNS Performance**:
   - Verify on-premises DNS servers are responsive
   - Check network latency to on-premises

3. **Transit Gateway Health**:
   - Verify Transit Gateway attachment is active
   - Check network path for packet loss

### Endpoint Failures

1. **Single Endpoint Failure**:
   - Automatic failover to other endpoint
   - No manual intervention required
   - Check CloudWatch logs for failure reason

2. **Both Endpoints Down**:
   - Critical infrastructure failure
   - Investigate VPC/subnet availability
   - Check Transit Gateway status
   - Review security group rules

## Cost Optimization

### Cost Drivers

1. **Resolver Endpoints**: ~$32/month per endpoint (2 endpoints = ~$64/month)
2. **Data Transfer**: ~$0.02 per GB egress to on-premises via TGW
3. **CloudWatch Logs**: ~$0.50/GB ingested (depends on query volume)
4. **CloudWatch Metrics**: ~$0.30 per custom metric per month

### Cost Optimization Strategies

1. **Log Retention**: Adjust log retention based on needs
   - Dev: 30 days (cheapest)
   - Staging: 60 days
   - Prod: 90 days

2. **Metrics**: Only create metrics for critical monitoring
   - Example: Error rate, not total query count

3. **Consolidate Rules**: Limit number of forwarding rules to 2-3 critical domains

4. **Capacity Planning**: Monitor query volume to right-size infrastructure

## Disaster Recovery

### Backup Strategy

Terraform state is versioned in S3:
- Automatic versioning enabled
- Point-in-time recovery available
- 30+ versions retained

### Rollback Procedure

If infrastructure changes cause issues:

1. **Identify Previous State Version**:
   ```bash
   aws s3api list-object-versions \
     --bucket terraform-state-009-hybrid-dns \
     --region us-east-1
   ```

2. **Restore from Previous Version**:
   ```bash
   # Note the VersionId from step 1
   aws s3api get-object \
     --bucket terraform-state-009-hybrid-dns \
     --key terraform.tfstate \
     --version-id <VERSION_ID> \
     terraform.tfstate.backup
   ```

3. **Reapply Previous Configuration**:
   ```bash
   terraform apply -state=terraform.tfstate.backup
   ```

## Maintenance

### Updating Variables

To update infrastructure configuration:

1. Edit the appropriate variable file (terraform.tfvars.{env})
2. Run `terraform plan` to preview changes
3. Run `terraform apply` to apply changes
4. Verify changes via CloudWatch or AWS Console

### Adding New Forwarding Rules

To add additional domain forwarding rules:

1. Copy the `aws_route53_resolver_rule` and `aws_route53_resolver_rule_association` blocks in `resolver.tf`
2. Update domain names and DNS servers
3. Run `terraform plan` and `terraform apply`

### Updating Security Groups

To modify allowed networks:

1. Edit security group rules in `security-groups.tf`
2. Update CIDR blocks as needed
3. Run `terraform plan` and `terraform apply`

## Support

For issues or questions:
1. Review CloudWatch logs for DNS errors
2. Check Terraform outputs for endpoint IPs and IDs
3. Verify AWS resources match expected configuration
4. Review plan.md and spec.md for design documentation

## Next Steps

After successful deployment:
1. Configure on-premises DNS clients to use inbound endpoint IP
2. Test DNS resolution from both cloud and on-premises
3. Monitor CloudWatch dashboard and logs
4. Set up Slack/PagerDuty notifications for alarms
5. Document endpoint IPs and configuration in runbooks
