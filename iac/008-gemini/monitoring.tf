# Monitoring and alerting for Pub/Sub
resource "google_monitoring_alert_policy" "pubsub_backlog_alert" {
  display_name = "Pub/Sub Subscription Backlog Alert"
  combiner     = "OR"
  conditions {
    display_name = "Subscription backlog is high"
    condition_threshold {
      filter          = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" AND resource.labels.subscription_id=\"${google_pubsub_subscription.order_processing_push_sub.name}\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 1000
      trigger {
        count = 1
      }
    }
  }
  project = var.project_id
}

resource "google_monitoring_alert_policy" "pubsub_volume_alert" {
  display_name = "Pub/Sub Topic Volume Anomaly Alert"
  combiner     = "OR"
  conditions {
    display_name = "Topic message volume is unexpectedly low"
    condition_threshold {
      filter          = "metric.type=\"pubsub.googleapis.com/topic/send_request_count\" AND resource.labels.topic_id=\"${google_pubsub_topic.order_events.name}\""
      duration        = "3600s"
      comparison      = "COMPARISON_LT"
      threshold_value = 1
      trigger {
        count = 1
      }
    }
  }
  project = var.project_id
}