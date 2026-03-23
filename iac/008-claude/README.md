# Order Processing Infrastructure - Google Cloud Platform

This directory contains Terraform infrastructure-as-code for the event-driven order processing platform on Google Cloud Platform (GCP).

## Architecture Overview

The infrastructure implements a serverless, event-driven architecture with:

- **Cloud Pub/Sub**: Message broker with Avro schema validation
- **Cloud Run**: Serverless compute (0-10 instances) for order processing
- **Cloud SQL**: PostgreSQL database for order data persistence
- **Cloud Storage**: GCS buckets for state management and message archival
- **Cloud Monitoring**: Dashboards, metrics, and alerting

## Prerequisites

### Tools Required
- Terraform >= 1.7
- Google Cloud SDK (gcloud CLI)
- Authentication: Service account with appropriate permissions

### GCP Project Setup
1. Create a GCP project
2. Create a GCS bucket for Terraform state: `terraform-state-{project-id}`
3. Create a service account for Terraform provisioning
4. Grant the service account Editor role (or more restrictive permissions)
5. Download the service account JSON key

### Environment Variables
```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account-key.json"
export GOOGLE_PROJECT_ID="your-gcp-project-id"
```

## File Structure

```
iac/
├── backend.tf              # GCS state backend configuration
├── provider.tf             # GCP provider configuration
├── versions.tf             # Terraform version constraints
├── variables.tf            # Input variable declarations
├── outputs.tf              # Output declarations
├── locals.tf               # Local values and naming conventions
│
├── service_accounts.tf     # Service accounts and IAM roles
├── secrets.tf              # Secret Manager for credentials
├── pubsub.tf               # Cloud Pub/Sub (topic, subscriptions, DLQ)
├── cloud_sql.tf            # Cloud SQL instance and Cloud Storage buckets
├── cloud_run.tf            # Cloud Run service with auto-scaling
├── monitoring.tf           # Cloud Logging, dashboards, alerts
│
├── terraform.tfvars        # Shared variables (GCP project ID, region)
├── terraform.tfvars.dev    # Dev environment variables
├── terraform.tfvars.staging # Staging environment variables
├── terraform.tfvars.prod   # Production environment variables
│
└── README.md               # This file
```

## Configuration

### GCP Project ID
Update `terraform.tfvars` with your GCP project ID:
```hcl
project_id = "your-gcp-project-id"
```

### Environment-Specific Configuration
Each environment (dev/staging/prod) has its own `.tfvars` file:

- **dev**: Minimal resources, cost-optimized (db-f1-micro, 0-2 Cloud Run instances)
- **staging**: Test-like configuration (db-n1-standard-1, 0-5 instances)
- **prod**: Full capacity with HA (db-n1-standard-4, 1-10 instances, HA replica)

## Provisioning

### Initialize Terraform Backend
```bash
cd iac/
terraform init
```

### Create Terraform Workspace
```bash
# For development environment
terraform workspace new dev
terraform workspace select dev
```

### Plan Infrastructure Changes
```bash
# Preview changes for dev environment
terraform plan -var-file=terraform.tfvars.dev
```

### Apply Infrastructure
```bash
# Deploy dev environment
terraform apply -var-file=terraform.tfvars.dev

# Deploy staging environment
terraform workspace select staging
terraform apply -var-file=terraform.tfvars.staging

# Deploy production environment (requires manual approval)
terraform workspace select prod
terraform apply -var-file=terraform.tfvars.prod
```

### Deployment Order
1. **Dev**: Complete Phase 1-7 and validate
2. **Staging**: Complete Phase 1-7 and test thoroughly
3. **Prod**: Complete Phase 1-7 with careful review

## Validation & Testing

### Terraform Validation
```bash
# Validate Terraform syntax
terraform validate

# Format code
terraform fmt -recursive
```

### Security Scanning
```bash
# Run Checkov security scanning
checkov -d iac/ --framework terraform

# Run tfsec security scanning
tfsec iac/ -s

# Run Infracost for cost estimation
infracost breakdown --path iac/
```

### Deployment Validation
After `terraform apply`, verify:

1. **Cloud Pub/Sub**
   ```bash
   gcloud pubsub topics describe order-events
   gcloud pubsub subscriptions describe order-events-cloud-run
   gcloud pubsub subscriptions describe order-events-analytics
   ```

2. **Cloud Run**
   ```bash
   gcloud run services describe order-processing-{env} --region us-central1
   gcloud run services get-iam-policy order-processing-{env} --region us-central1
   ```

3. **Cloud SQL**
   ```bash
   gcloud sql instances describe order-processing-{env}-db
   gcloud sql databases describe order_processing_db --instance order-processing-{env}-db
   ```

4. **Cloud Storage**
   ```bash
   gsutil ls gs://terraform-state-{project-id}/
   gsutil ls gs://order-events-archive-{project-id}/
   ```

## Troubleshooting

### Common Issues

#### 1. Backend Authentication Error
**Error**: `Error: Error when reading or editing Network: googleapi: Error 403`

**Solution**:
- Verify GCP credentials: `gcloud auth list`
- Check service account permissions
- Ensure terraform-state bucket exists and is accessible

#### 2. Cloud SQL Connection Timeout
**Error**: `Error applying plan: Error, failed to create instance`

**Solution**:
- Check GCP quota for Cloud SQL instances
- Verify network connectivity (if using VPC)
- Check service account permissions

#### 3. Cloud Run Deployment Failure
**Error**: `Error: Error creating Service: googleapi: Error 403`

**Solution**:
- Verify Cloud Run API is enabled: `gcloud services enable run.googleapis.com`
- Check service account has `run.admin` permissions
- Verify container image is accessible

#### 4. Pub/Sub Schema Validation Error
**Error**: `Error creating Topic: googleapi: Error 400: Invalid schema`

**Solution**:
- Verify Avro schema syntax in `locals.tf`
- Check schema fields match Pub/Sub requirements
- Ensure schema is properly formatted as JSON

### Debugging Commands

```bash
# Check Terraform state
terraform state list
terraform state show google_cloud_run_service.order_processor

# View Terraform logs
TF_LOG=DEBUG terraform apply

# Check GCP service enablement
gcloud services list --enabled | grep -E "pubsub|run|sql|storage"

# View Cloud Logging
gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=order-processing-dev" --limit 50

# Test Pub/Sub connectivity
gcloud pubsub topics publish order-events --message '{"order_id":"test"}'

# Test Cloud SQL connection
gcloud sql connect order-processing-dev-db --user=postgres
```

## Cost Management

### Cost Estimation
```bash
# Generate cost breakdown
infracost breakdown --path iac/ --format table

# Compare environments
infracost diff --path iac/ \
  --terraform-var-file terraform.tfvars.dev \
  --terraform-var-file terraform.tfvars.prod
```

### Cost Optimization
- **Dev**: Use db-f1-micro (shared), 0 min instances (scales to 0)
- **Staging**: Use db-n1-standard-1, 0 min instances
- **Prod**: Use db-n1-standard-4 with HA, 1 min instance (availability SLO)

### Cleanup
```bash
# Destroy infrastructure (USE WITH CAUTION!)
terraform destroy -var-file=terraform.tfvars.dev
```

⚠️ **WARNING**: Destroying infrastructure will:
- Delete Cloud SQL databases
- Remove Cloud Pub/Sub topics and subscriptions
- Delete Cloud Run services
- **NOT** delete Cloud Storage buckets (protected by `prevent_destroy`)

## Monitoring & Observability

### Dashboards
- **Cloud Monitoring Dashboard**: Pub/Sub metrics, Cloud Run instances, Cloud SQL connections
- **Cloud Logging**: Application logs, API logs, audit logs

### Alerts
- DLQ message arrival (failure detection)
- Cloud Run error rate > 10 errors/5min
- Cloud SQL connection pool > 80% utilization

### Metrics
```bash
# View Cloud Pub/Sub metrics
gcloud monitoring time-series list \
  --filter 'metric.type="pubsub.googleapis.com/topic/send_message_operation_count"'

# View Cloud Run metrics
gcloud monitoring time-series list \
  --filter 'metric.type="run.googleapis.com/request_count"'
```

## Security

### Service Accounts
- **Cloud Run SA**: pubsub.subscriber, cloudsql.client, logging.logWriter
- **Analytics SA**: pubsub.subscriber, storage.objectViewer
- **Terraform SA**: editor (dev/staging), custom policy (prod)

### Secrets Management
- Cloud SQL passwords stored in Secret Manager (not in .tfvars)
- Database connections via Cloud SQL Auth Proxy (secure proxy)
- All data encrypted at-rest (AES-256) and in-transit (TLS 1.2+)

### IAM Least Privilege
- Service accounts have minimal required permissions
- No public endpoints (Cloud Run accessible only via Pub/Sub)
- No hardcoded credentials in environment variables

## Maintenance

### State Management
```bash
# Backup state
gsutil cp gs://terraform-state-{project-id}/terraform/state .

# Verify state
terraform state list | wc -l

# Refresh state
terraform refresh -var-file=terraform.tfvars.dev
```

### Version Updates
```bash
# Check for latest provider versions
terraform providers

# Update provider versions in versions.tf
# Then run:
terraform init -upgrade
```

## Support & Documentation

- **Terraform Registry**: https://registry.terraform.io/providers/hashicorp/google/latest/docs
- **GCP Documentation**: https://cloud.google.com/docs
- **Pub/Sub Documentation**: https://cloud.google.com/pubsub/docs
- **Cloud Run Documentation**: https://cloud.google.com/run/docs
- **Cloud SQL Documentation**: https://cloud.google.com/sql/docs

## License

This infrastructure code is provided as-is for the order processing platform.
