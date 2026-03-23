# Main Pub/Sub topic for order events
resource "google_pubsub_topic" "order_events" {
  name    = "order-events"
  project = var.project_id
  labels = {
    "environment" = terraform.workspace
  }
  message_retention_duration = "604800s" # 7 days
}

# Avro schema for the order events
resource "google_pubsub_schema" "order_events_schema" {
  name    = "order-events-schema"
  project = var.project_id
  type    = "AVRO"
  definition = jsonencode({
    "type" : "record",
    "name" : "OrderEvent",
    "fields" : [
      {
        "name" : "order_id",
        "type" : "string"
      },
      {
        "name" : "customer_id",
        "type" : "string"
      },
      {
        "name" : "timestamp",
        "type" : "long"
      }
    ]
  })
}

# Attach schema to the topic
resource "google_pubsub_topic" "order_events_schema_attachment" {
  name    = google_pubsub_topic.order_events.name
  project = var.project_id
  schema_settings {
    schema   = "projects/${var.project_id}/schemas/${google_pubsub_schema.order_events_schema.name}"
    encoding = "JSON"
  }
  depends_on = [google_pubsub_topic.order_events, google_pubsub_schema.order_events_schema]
}


# Dead-letter topic for schema validation failures
resource "google_pubsub_topic" "order_events_dlq" {
  name    = "order-events-dlq"
  project = var.project_id
}

# Subscription for the dead-letter topic
resource "google_pubsub_subscription" "order_events_dlq_sub" {
  name    = "order-events-dlq-sub"
  project = var.project_id
  topic   = google_pubsub_topic.order_events_dlq.name
}

# Push subscription for the Cloud Run service
resource "google_pubsub_subscription" "order_processing_push_sub" {
  name    = "order-processing-push-sub"
  project = var.project_id
  topic   = google_pubsub_topic.order_events.name

  push_config {
    push_endpoint = google_cloud_run_v2_service.order_processing_service.uri

    oidc_token {
      service_account_email = google_service_account.order_processing_sa.email
    }
  }

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.order_events_dlq.id
    max_delivery_attempts = 5
  }

  enable_message_ordering = true
}

# Pull subscription for the analytics service
resource "google_pubsub_subscription" "analytics_pull_sub" {
  name    = "analytics-pull-sub"
  project = var.project_id
  topic   = google_pubsub_topic.order_events.name

  ack_deadline_seconds = 60
}
