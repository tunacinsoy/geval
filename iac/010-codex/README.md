# Hardened Image Pipeline IaC

This directory contains Terraform code that implements the hardened AMI pipeline described in `specs/001-hardened-ami-pipeline/spec.md`.

## Getting started
1. Populate remote state bucket and DynamoDB table names via `terraform.tfvars` or workspace overrides.
2. Run `terraform init` in `iac/` to bootstrap providers and backend.
3. Run the tasks listed in `specs/001-hardened-ami-pipeline/tasks.md` phase-by-phase (Setup → Network → Compute → Application → Polish).
4. After validations (`terraform validate`, `terraform plan`), promote to staging/prod using the respective tfvars.
