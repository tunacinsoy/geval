# Shared Terraform Variables (loaded automatically)
# Replace with your actual GCP project ID
# project_id = "your-gcp-project-id"

region = "us-central1"

# Pub/Sub Configuration
pubsub_dead_letter_retention_days = 7
pubsub_max_delivery_attempts      = 3

# Cloud Run Configuration
cloud_run_memory          = "512Mi"
cloud_run_cpu             = "0.5"
cloud_run_timeout_seconds = 60
cloud_run_concurrency     = 200

# Cloud SQL Configuration
cloud_sql_version = "15"
