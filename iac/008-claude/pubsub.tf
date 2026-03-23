# ============================================================================
# Cloud Pub/Sub Topic for Order Events
# ============================================================================

module "pubsub_topic" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 8.6"

  project_id = var.project_id
  topic      = local.pubsub_topic_name

  topic_labels = merge(
    local.common_labels,
    {
      "component" = "order-events-topic"
    }
  )

  message_retention_duration = "${var.pubsub_message_retention_days * 86400}s"

  schema_settings = {
    schema   = google_pubsub_schema.order_events_avro.id
    encoding = "JSON"
  }
}

# ============================================================================
# Avro Schema for Order Events
# ============================================================================

resource "google_pubsub_schema" "order_events_avro" {
  project    = var.project_id
  name       = "${local.pubsub_topic_name}-avro-schema"
  type       = "AVRO"
  definition = local.avro_schema
}

# ============================================================================
# Push Subscription - Cloud Run
# ============================================================================

resource "google_pubsub_subscription" "push_subscription" {
  project = var.project_id
  name    = local.pubsub_push_sub_name
  topic   = module.pubsub_topic.topic

  ack_deadline_seconds       = 60
  message_retention_duration = "${var.pubsub_message_retention_days * 86400}s"

  labels = merge(
    local.common_labels,
    {
      "subscription-type" = "push"
      "target"            = "cloud-run"
    }
  )

  push_config {
    push_endpoint = "${google_cloud_run_service.order_processor.status[0].url}/"
    oidc_token {
      service_account_email = google_service_account.cloud_run_sa.email
    }
  }

  dead_letter_policy {
    dead_letter_topic     = module.pubsub_dlq_topic.id
    max_delivery_attempts = var.pubsub_max_delivery_attempts
  }

  depends_on = [
    google_cloud_run_service.order_processor,
    module.pubsub_dlq_topic
  ]
}

# ============================================================================
# Pull Subscription - Analytics/Archival Service
# ============================================================================

resource "google_pubsub_subscription" "pull_subscription" {
  project = var.project_id
  name    = local.pubsub_pull_sub_name
  topic   = module.pubsub_topic.topic

  ack_deadline_seconds       = 60
  message_retention_duration = "${var.pubsub_message_retention_days * 86400}s"

  enable_message_ordering = true

  labels = merge(
    local.common_labels,
    {
      "subscription-type" = "pull"
      "target"            = "analytics"
    }
  )

  depends_on = [module.pubsub_topic]
}

# ============================================================================
# Dead-Letter Queue (DLQ) Topic
# ============================================================================

module "pubsub_dlq_topic" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 8.6"

  project_id = var.project_id
  topic      = local.pubsub_dlq_topic_name

  topic_labels = merge(
    local.common_labels,
    {
      "component" = "dead-letter-queue"
    }
  )

  message_retention_duration = "${var.pubsub_dead_letter_retention_days * 86400}s"
}

# ============================================================================
# Pub/Sub Outputs
# ============================================================================

output "pubsub_topic_details" {
  description = "Cloud Pub/Sub topic details"
  value = {
    name                   = module.pubsub_topic.topic
    id                     = module.pubsub_topic.id
    message_retention_days = var.pubsub_message_retention_days
    schema                 = google_pubsub_schema.order_events_avro.name
  }
}

output "pubsub_subscriptions" {
  description = "Cloud Pub/Sub subscriptions"
  value = {
    push_subscription = {
      name          = google_pubsub_subscription.push_subscription.name
      id            = google_pubsub_subscription.push_subscription.id
      push_endpoint = google_cloud_run_service.order_processor.status[0].url
      type          = "push"
    }
    pull_subscription = {
      name = google_pubsub_subscription.pull_subscription.name
      id   = google_pubsub_subscription.pull_subscription.id
      type = "pull"
    }
    dlq_topic = {
      name = module.pubsub_dlq_topic.topic
      id   = module.pubsub_dlq_topic.id
    }
  }
}