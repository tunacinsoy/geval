# High-Availability DNS Resolver Bridge IaC

This directory contains Terraform code for provisioning the Route 53 Resolver endpoints, forwarding rule, Transit Gateway routing, and associated telemetry for the corp.internal domain.

## Structure
- `backend.tf` configures the shared S3/DynamoDB backend (adjust `bucket`, `key`, and `dynamodb_table` via `terraform init -backend-config`).
- `provider.tf`, `variables.tf`, and `versions.tf` declare provider settings and pinned versions.
- `vpc.tf`, `networking.tf`, and `security-groups.tf` build the VPC foundation, route tables, and port 53 controls.
- `resolver-endpoints.tf`, `dns.tf`, and `transit-gateway.tf` create the hybrid DNS pieces referenced by the plan.
- `logging.tf` and `monitoring.tf` capture telemetry into CloudWatch and GuardDuty.
- `outputs.tf` exposes critical IDs for operator handoff.
- `modules/` contains reusable resolver and Transit Gateway routing fragments.

## Environments
Three environment files provide overrides:
- `terraform.tfvars.dev`
- `terraform.tfvars.staging`
- `terraform.tfvars.prod`

Invoke `terraform init -backend-config=env/backend.hcl` or pass overrides:
```
terraform init \
  -backend-config="bucket=resolver-bridge-${var.environment}-state" \
  -backend-config="key=${var.environment}/terraform.tfstate"
```

Each environment uses its own `key` path in the same S3 bucket to avoid state collisions.
