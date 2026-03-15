# Playground Infrastructure

## Overview
This Terraform configuration provisions the short-lived playground described in the spec.
Compute resources sit behind an Application Load Balancer, logging lives in CloudWatch/S3, and an automated reminder warns the team when the two-week window ends.

## Quickstart
```bash
cd iac
terraform init -backend-config=backend.tf
terraform workspace new playground || terraform workspace select playground
terraform apply -var-file=playground.tfvars
```

## Teardown
To destroy the playground when work completes:
```bash
terraform destroy -var-file=playground.tfvars
```

## Notes
- The ALB listener references a placeholder certificate ARN; update it before creating real load balancers.
- Automation sends daily notifications to the feature team email before the scheduled teardown date.
