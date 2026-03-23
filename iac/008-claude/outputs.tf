# Pub/Sub Outputs
output "pubsub_topic_id" {
  description = "Cloud Pub/Sub topic ID"
  value       = module.pubsub_topic.topic_id
}

output "pubsub_topic_name" {
  description = "Cloud Pub/Sub topic name"
  value       = module.pubsub_topic.topic
}

output "pubsub_push_subscription_id" {
  description = "Push subscription ID (to Cloud Run)"
  value       = module.pubsub_push_subscription.subscription_id
}

output "pubsub_pull_subscription_id" {
  description = "Pull subscription ID (for analytics)"
  value       = module.pubsub_pull_subscription.subscription_id
}

output "pubsub_dlq_topic_id" {
  description = "Dead-letter queue topic ID"
  value       = module.pubsub_dlq_topic.topic_id
}

# Cloud Run Outputs
output "cloud_run_service_name" {
  description = "Cloud Run service name"
  value       = google_cloud_run_service.order_processor.name
}

output "cloud_run_service_url" {
  description = "Cloud Run service URL"
  value       = google_cloud_run_service.order_processor.status[0].url
  sensitive   = false
}

output "cloud_run_service_sa_email" {
  description = "Cloud Run service account email"
  value       = google_service_account.cloud_run_sa.email
}

# Cloud SQL Outputs
output "cloud_sql_instance_name" {
  description = "Cloud SQL instance name"
  value       = module.cloud_sql.instance_name
}

output "cloud_sql_instance_connection_name" {
  description = "Cloud SQL instance connection name (for Auth Proxy)"
  value       = module.cloud_sql.instance_connection_name
}

output "cloud_sql_private_ip" {
  description = "Cloud SQL private IP address"
  value       = module.cloud_sql.instance_private_ip
}

output "cloud_sql_database_name" {
  description = "Cloud SQL database name"
  value       = google_sql_database.order_processing.name
}

# Cloud Storage Outputs
output "terraform_state_bucket_name" {
  description = "GCS bucket for Terraform state"
  value       = google_storage_bucket.terraform_state.name
}

output "archive_bucket_name" {
  description = "GCS bucket for message archival"
  value       = google_storage_bucket.archive.name
}

# Service Account Outputs
output "cloud_run_service_account_email" {
  description = "Cloud Run service account email"
  value       = google_service_account.cloud_run_sa.email
}

output "analytics_service_account_email" {
  description = "Analytics service account email"
  value       = google_service_account.analytics_sa.email
}

# Monitoring Outputs
output "monitoring_dashboard_id" {
  description = "Cloud Monitoring dashboard ID"
  value       = try(google_monitoring_dashboard.order_processing.dashboard_json, "")
}

# Summary
output "infrastructure_summary" {
  description = "Infrastructure deployment summary"
  value = {
    environment             = var.environment
    region                  = var.region
    pubsub_topic            = module.pubsub_topic.topic
    cloud_run_service       = google_cloud_run_service.order_processor.name
    cloud_sql_instance      = module.cloud_sql.instance_name
    cloud_run_min_instances = var.cloud_run_min_instances
    cloud_run_max_instances = var.cloud_run_max_instances
    message_retention_days  = var.pubsub_message_retention_days
  }
  sensitive = false
}
