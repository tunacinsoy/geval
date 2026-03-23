resource "google_pubsub_schema" "order_events" {
  name       = var.schema_id
  definition = data.local_file.avro_schema.content
  type       = "AVRO"
}

resource "google_pubsub_topic" "order_events" {
  name   = var.topic_name
  labels = local.default_labels
  schema_settings {
    schema   = google_pubsub_schema.order_events.id
    encoding = "JSON"
  }
}

resource "google_pubsub_topic" "dead_letter" {
  name   = "${var.topic_name}-dlq"
  labels = local.default_labels
}

resource "google_pubsub_subscription" "push" {
  name                       = var.push_subscription_name
  topic                      = google_pubsub_topic.order_events.id
  ack_deadline_seconds       = var.pubsub_ack_deadline_seconds
  message_retention_duration = format("%ss", var.pubsub_retention_duration_seconds)
  labels                     = local.default_labels

  push_config {
    push_endpoint = google_cloud_run_service.order_processor.status[0].url
    oidc_token {
      service_account_email = google_service_account.order_processor.email
    }
  }
  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.dead_letter.id
    max_delivery_attempts = 5
  }
}

resource "google_pubsub_subscription" "analytics_pull" {
  name                       = var.pull_subscription_name
  topic                      = google_pubsub_topic.order_events.id
  ack_deadline_seconds       = var.pubsub_ack_deadline_seconds
  message_retention_duration = format("%ss", var.pubsub_retention_duration_seconds)
  labels                     = local.default_labels
  enable_message_ordering    = true
  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }
}
