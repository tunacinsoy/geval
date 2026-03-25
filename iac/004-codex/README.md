# Customer Order Database Platform IaC

This directory contains Terraform code that provisions the AWS resources described in the architecture plan. Each environment (dev/staging/prod) is configured through corresponding `terraform.tfvars.*` files.

## Getting Started

1. Install Terraform 1.14.7.
2. Export AWS credentials for the account that holds the `proj-terraform-state` backend bucket and `proj-terraform-lock` table.
3. Run `terraform init` to bootstrap providers and backend.
4. Select the workspace (`dev`, `staging`, `prod`) and apply the configuration with `terraform workspace select <env>` followed by `terraform plan -var-file=terraform.tfvars.<env>`.
5. Apply once the plan looks good.

## Structure

- `backend.tf`: Remote state configuration (S3 + DynamoDB).
- `provider.tf`: AWS provider configuration.
- `versions.tf`: Terraform and provider version constraints.
- `variables.tf`: Shared input variables.
- `networking.tf`: VPC, subnet, and endpoint definitions.
- `security-groups.tf`: Security groups for RDS, ECS, and Lambda.
- `iam.tf`: IAM roles/policies for ECS tasks and Lambda functions.
- `database.tf`: RDS PostgreSQL cluster provisioning.
- `storage.tf`: S3 buckets for import/export/audit data plus lifecycle rules.
- `secrets.tf`: Secrets Manager secrets capturing the database credentials.
- `compute.tf`: ECS cluster/service, Lambda, CloudWatch schedule.
- `monitoring.tf`: Dashboards and alarms wired to SNS.
- `notifications.tf`: SNS topic/subscriptions for alerts.
- `dns.tf`: Private hosted zone and record pointing to the database endpoint.
- `outputs.tf`: Key endpoints and identifiers downstream teams require.

## Environment Files

- `terraform.tfvars.dev`: Keeps costs low with smaller instances and shorter retention.
- `terraform.tfvars.staging`: Mirrors production topology but at reduced scale.
- `terraform.tfvars.prod`: Production sizing, multi-AZ backups, read replicas.
