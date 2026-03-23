# Define any outputs here, for example:
output "cloud_run_service_url" {
  description = "The URL of the deployed Cloud Run service."
  value       = google_cloud_run_v2_service.order_processing_service.uri
}

output "pubsub_topic_name" {
  description = "The name of the main Pub/Sub topic."
  value       = google_pubsub_topic.order_events.name
}
