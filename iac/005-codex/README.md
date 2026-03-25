# Global Image Delivery Accelerator IaC

## Overview
This Terraform project implements the AWS CloudFront + S3 based CDN described in `specs/001-accelerate-cdn/spec.md` and `plan.md`.

## Prerequisites
- Terraform 1.14.x (lockstep with `versions.tf`)
- AWS CLI configured with access to S3, CloudFront, WAF, and IAM resources

## Basic Commands
```bash
terraform init -backend-config="table_name=global-image-delivery-terraform-lock"
terraform plan -var-file=iac/envs/dev.tfvars
terraform apply -var-file=iac/envs/dev.tfvars
```

## Environment Promotion
Use `iac/envs/staging.tfvars` and `iac/envs/prod.tfvars` for the respective phases. Run `terraform plan` for each environment before applying to ensure validation passes.
