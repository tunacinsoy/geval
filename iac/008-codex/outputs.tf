output "pubsub_topic" {
  value = google_pubsub_topic.order_events.name
}

output "push_subscription" {
  value = google_pubsub_subscription.push.id
}

output "pull_subscription" {
  value = google_pubsub_subscription.analytics_pull.id
}

output "cloud_run_url" {
  value = google_cloud_run_service.order_processor.status[0].url
}

output "service_account_email" {
  value = google_service_account.order_processor.email
}

output "cloud_sql_connection_name" {
  value = google_sql_database_instance.order_processor.connection_name
}

output "analytics_dataset_id" {
  value = google_bigquery_dataset.analytics.dataset_id
}
