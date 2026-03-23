# Order Event Messaging Infrastructure

This directory houses the Terraform configuration for the `order-events` Pub/Sub topic, push/pull subscriptions, Cloud Run processing service, and Cloud SQL connectivity described in the plan and spec.

## Structure
- `backend.tf`, `versions.tf`, `provider.tf`, `variables.tf`, and `outputs.tf` define shared platform settings.
- `networking.tf` configures the private network, subnets, connectors, and firewall rules required by Cloud Run and Cloud SQL.
- `pubsub.tf`, `cloudrun.tf`, `cloudsql.tf`, and `storage.tf` capture the topic schema, serverless execution, database, and analytics dataset.
- `iam.tf` provisions the dedicated service account plus IAM bindings and secret manager access.
- `monitoring.tf` defines alerting for schema validation failures, Cloud Run errors, and Pub/Sub backlog.
- `terraform.tfvars.{env}` files customize scale, retention, and database sizing for dev, staging, and prod.
- `schemas/order-events.avsc` holds the Avro schema referenced by the Pub/Sub topic.

## Initialization
1. Install Terraform 1.14.x and configure credentials with `gcloud auth application-default login`.
2. Run `terraform init` inside this directory to provision providers and backend modules.
3. Use the workspace-per-environment convention (e.g., `order-event-messaging-dev`) defined in `backend.tf`.

## Testing/Validation
- Run `terraform fmt` after edits.
- Run `terraform validate` in each workspace before applying changes.
- Use `terraform plan -var-file=terraform.tfvars.dev` (or staging/prod) to preview the resource graph.
