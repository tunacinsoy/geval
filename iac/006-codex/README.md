# Infrastructure Deployment Guide

## Directory Layout
- `iac/`: Terraform code (backend, provider, networking, compute, database, monitoring, secrets)
- `iac/modules/`: Reusable module stubs for network, compute, database, and observability
- `iac/env/{dev,staging,prod}`: Environment-specific data folders (if needed)

## Environment Promotion
1. Apply `iac/terraform.tfvars.dev` for the dev workspace to validate the network and compute tiers.
2. Once dev passes the `terraform validate`/`plan` gates, rerun with `iac/terraform.tfvars.staging` to mirror production behavior.
3. After staging verification (including DR drill), deploy with `iac/terraform.tfvars.prod` to create production resources.

## Backend Keys
Each environment uses `key = "${var.environment}/terraform.tfstate"` so state files stay isolated. Ensure the DynamoDB lock table `terraform-state-locks` exists in eu-central-1 before running parallel applies.

## Variable Overrides
Adjust these variables per environment as needed:
- `application_desired_capacity`: baseline instances per ASG
- `enable_nat_instances`: flips between NAT gateway vs. instance in cost-sensitive environments
- `dns_domain`/`dns_zone_id`: set to the hosted zone covering the application domain
