# Secure HR Document Infrastructure

## Setup
1. Configure AWS credentials and confirm `terraform` CLI (>= 1.14). 
2. Run `terraform init` in this directory to bootstrap plugins and backends.
3. Use `terraform workspace select dev` (or staging/prod) before planning.

## Workflows
- Use `terraform plan` before apply and `terraform apply` only after validation. 
- Guard the S3 bucket by enforcing lifecycle policies and verifying replication status.
- Keep secrets and TLS certificates rotated via AWS Secrets Manager.
