# Flower Shop Website Infrastructure

## Overview
This directory defines the Terraform infrastructure for hosting the flower shop's static website via S3, CloudFront, and Route 53. TLS certificates live in ACM (us-east-1) and the infrastructure is secured with strict bucket policies and alerting for elevated error rates.

## Getting Started
1. Install Terraform 1.14.4 (or compatible 1.14.x release) and configure AWS credentials.
2. Populate `iac/terraform.tfvars.prod` (and staging/dev) with real domain names, hosted zone IDs, and alerting emails.
3. Ensure the backend bucket (`flower-shop-terraform-state`) and DynamoDB table (`flower-shop-terraform-locks`) exist before running `terraform init`. They must be created manually or via a bootstrap run.
4. Run `terraform init` from this directory to configure the backend and download providers.
5. Use `terraform plan -var-file=iac/terraform.tfvars.prod` before applying to validate the changes.
6. After deployment, publish static assets to the S3 bucket and invalidate CloudFront when needed.

## Deployment Notes
- TLS certificates require DNS validation; the plan creates Route 53 records automatically using the hosted zone ID provided.
- CloudFront logs are stored in the dedicated logging bucket; set up lifecycle rules there to manage retention.
- Alerts are delivered via SNS to the address defined in `deployment_email`.

## Maintenance
- Update `iac/variables.tf` only when adding new configurable knobs (e.g., cache TTL, domains).
- Use `terraform fmt` after editing `.tf` files and `tfsec`/`Infracost` to keep security/cost visibility.
