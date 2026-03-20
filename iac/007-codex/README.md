# Infrastructure IaC

This directory contains Terraform configuration for the private Azure Kubernetes Service cluster described in `specs/001-deploy-private-k8s/spec.md`.

## Layout
- `backend.tf`, `provider.tf`, `versions.tf`: Terraform bootstrapping and Azure provider definitions.
- `network.tf`, `firewall.tf`: Virtual network, firewall, and routing required before cluster creation.
- `compute.tf`: AKS cluster with Azure CNI overlay networking and the zonal node pool.
- `logging.tf`, `monitoring.tf`: Observability resources including Log Analytics, diagnostics, and alerts.
- `security.tf`: NSG controls and Key Vault with workload identities.
- `outputs.tf`: Key values for automation handoffs.
- `terraform.tfvars.{env}`: Environment-specific variable overrides.
- `modules/`: Placeholder directories for reusable modules referenced in the plan.

## Getting Started
1. Populate `terraform.tfvars.{env}` with subscription-specific values.
2. Run `terraform init` to configure the Azure backend and download providers.
3. Apply the configuration per phase, using `terraform plan -var-file=iac/terraform.tfvars.prod` for production previews.
