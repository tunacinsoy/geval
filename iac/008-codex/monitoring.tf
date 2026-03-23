resource "google_monitoring_alert_policy" "pubsub_backlog" {
  display_name = "Pub/Sub backlog exceeds threshold"
  combiner     = "OR"
  conditions {
    display_name = "order-events backlog"
    condition_threshold {
      filter          = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.subscription_id=\"${google_pubsub_subscription.analytics_pull.name}\""
      comparison      = "COMPARISON_GT"
      threshold_value = 5000
      duration        = "900s"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_SUM"
      }
    }
  }
  notification_channels = []
}

resource "google_monitoring_alert_policy" "cloud_run_errors" {
  display_name = "Cloud Run processing errors"
  combiner     = "OR"
  conditions {
    display_name = "Cloud Run error rate"
    condition_threshold {
      filter          = "metric.type=\"run.googleapis.com/service/request_count\" resource.type=\"cloud_run_revision\" resource.label.service_name=\"${google_cloud_run_service.order_processor.name}\""
      comparison      = "COMPARISON_GT"
      threshold_value = 5
      duration        = "300s"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
}

resource "google_monitoring_alert_policy" "cloudsql_auth" {
  display_name = "Cloud SQL auth proxy failures"
  combiner     = "OR"
  conditions {
    display_name = "Cloud SQL failed connections"
    condition_threshold {
      filter          = "metric.type=\"cloudsql.googleapis.com/database/instance/failed_connections\" resource.label.database_id=\"${google_sql_database_instance.order_processor.name}\""
      comparison      = "COMPARISON_GT"
      threshold_value = 5
      duration        = "300s"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_SUM"
      }
    }
  }
}
