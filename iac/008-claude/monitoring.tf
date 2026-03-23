# ============================================================================
# Cloud Logging Sinks for Log Aggregation
# ============================================================================

resource "google_logging_project_sink" "pubsub_sink" {
  name        = "${local.resource_prefix}-pubsub-logs"
  destination = "logging.googleapis.com/projects/${var.project_id}/logs/pubsub"
  filter      = "resource.type=\"pubsub_topic\" OR resource.type=\"pubsub_subscription\""

  unique_writer_identity = true
}

resource "google_logging_project_sink" "cloud_run_sink" {
  name        = "${local.resource_prefix}-cloud-run-logs"
  destination = "logging.googleapis.com/projects/${var.project_id}/logs/cloud-run"
  filter      = "resource.type=\"cloud_run_revision\""

  unique_writer_identity = true
}

resource "google_logging_project_sink" "cloud_sql_sink" {
  name        = "${local.resource_prefix}-cloud-sql-logs"
  destination = "logging.googleapis.com/projects/${var.project_id}/logs/cloud-sql"
  filter      = "resource.type=\"cloudsql_database\""

  unique_writer_identity = true
}

# ============================================================================
# Log Retention Policy
# ============================================================================

resource "google_logging_project_sink" "retention_sink" {
  name        = "${local.resource_prefix}-retention"
  destination = "logging.googleapis.com/projects/${var.project_id}/logs/_Default"
  filter      = "severity >= DEFAULT"

  bigquery_options {
    use_partitioned_tables = true
  }
}

# ============================================================================
# Cloud Monitoring Dashboard
# ============================================================================

resource "google_monitoring_dashboard" "order_processing" {
  dashboard_json = jsonencode({
    displayName = "Order Processing Infrastructure"
    mosaicLayout = {
      columns = 12
      tiles = [
        # Cloud Pub/Sub Metrics
        {
          width  = 6
          height = 4
          widget = {
            title = "Pub/Sub Topic - Publish Rate"
            xyChart = {
              dataSets = [
                {
                  timeSeriesQuery = {
                    timeSeriesFilter = {
                      filter = "metric.type=\"pubsub.googleapis.com/topic/send_message_operation_count\" resource.type=\"pubsub_topic\" resource.labels.topic_id=\"${module.pubsub_topic.topic}\""
                      aggregation = {
                        alignmentPeriod  = "60s"
                        perSeriesAligner = "ALIGN_RATE"
                      }
                    }
                  }
                  plotType = "LINE"
                }
              ]
            }
          }
        },
        # Subscription Backlog
        {
          xPos   = 6
          width  = 6
          height = 4
          widget = {
            title = "Subscription - Backlog Size"
            xyChart = {
              dataSets = [
                {
                  timeSeriesQuery = {
                    timeSeriesFilter = {
                      filter = "metric.type=\"pubsub.googleapis.com/subscription/num_unacked_messages\" resource.type=\"pubsub_subscription\""
                      aggregation = {
                        alignmentPeriod  = "60s"
                        perSeriesAligner = "ALIGN_MEAN"
                      }
                    }
                  }
                  plotType = "LINE"
                }
              ]
            }
          }
        },
        # Cloud Run Request Count
        {
          yPos   = 4
          width  = 6
          height = 4
          widget = {
            title = "Cloud Run - Request Count"
            xyChart = {
              dataSets = [
                {
                  timeSeriesQuery = {
                    timeSeriesFilter = {
                      filter = "metric.type=\"run.googleapis.com/request_count\" resource.type=\"cloud_run_revision\" resource.labels.service_name=\"${local.cloud_run_service_name}\""
                      aggregation = {
                        alignmentPeriod  = "60s"
                        perSeriesAligner = "ALIGN_RATE"
                      }
                    }
                  }
                  plotType = "LINE"
                }
              ]
            }
          }
        },
        # Cloud Run Error Rate
        {
          xPos   = 6
          yPos   = 4
          width  = 6
          height = 4
          widget = {
            title = "Cloud Run - Error Rate"
            xyChart = {
              dataSets = [
                {
                  timeSeriesQuery = {
                    timeSeriesFilter = {
                      filter = "metric.type=\"run.googleapis.com/request_count\" resource.type=\"cloud_run_revision\" metric.labels.response_code_class=\"5xx\" resource.labels.service_name=\"${local.cloud_run_service_name}\""
                      aggregation = {
                        alignmentPeriod  = "60s"
                        perSeriesAligner = "ALIGN_RATE"
                      }
                    }
                  }
                  plotType = "LINE"
                }
              ]
            }
          }
        },
        # Cloud Run Instance Count
        {
          yPos   = 8
          width  = 6
          height = 4
          widget = {
            title = "Cloud Run - Instance Count"
            xyChart = {
              dataSets = [
                {
                  timeSeriesQuery = {
                    timeSeriesFilter = {
                      filter = "metric.type=\"run.googleapis.com/instance_count\" resource.type=\"cloud_run_revision\" resource.labels.service_name=\"${local.cloud_run_service_name}\""
                      aggregation = {
                        alignmentPeriod  = "60s"
                        perSeriesAligner = "ALIGN_MEAN"
                      }
                    }
                  }
                  plotType = "STACKED_BAR"
                }
              ]
            }
          }
        },
        # Cloud SQL Connections
        {
          xPos   = 6
          yPos   = 8
          width  = 6
          height = 4
          widget = {
            title = "Cloud SQL - Active Connections"
            xyChart = {
              dataSets = [
                {
                  timeSeriesQuery = {
                    timeSeriesFilter = {
                      filter = "metric.type=\"cloudsql.googleapis.com/database/network/connections\" resource.type=\"cloudsql_database\" resource.labels.database_id=\"${var.project_id}:${local.cloud_sql_instance_name}\""
                      aggregation = {
                        alignmentPeriod  = "60s"
                        perSeriesAligner = "ALIGN_MEAN"
                      }
                    }
                  }
                  plotType = "LINE"
                }
              ]
            }
          }
        }
      ]
    }
  })

  depends_on = [
    google_cloud_run_service.order_processor,
    module.pubsub_topic
  ]
}

# ============================================================================
# Alert Policies
# ============================================================================

# Alert: Dead-Letter Queue Messages Received
resource "google_monitoring_alert_policy" "dlq_messages" {
  display_name = "${local.resource_prefix}-dlq-alert"
  combiner     = "OR"

  conditions {
    display_name = "DLQ message arrival"

    condition_threshold {
      filter          = "metric.type=\"pubsub.googleapis.com/subscription/pull_message_operation_count\" resource.type=\"pubsub_subscription\" metric.labels.subscription_id=\"${module.pubsub_dlq_topic.topic}\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [] # Set notification channels in actual deployment

  labels = merge(
    local.common_labels,
    {
      "alert-type" = "dlq"
    }
  )
}

# Alert: Cloud Run Error Rate High
resource "google_monitoring_alert_policy" "cloud_run_error_rate" {
  display_name = "${local.resource_prefix}-cloud-run-errors"
  combiner     = "OR"

  conditions {
    display_name = "Cloud Run error rate"

    condition_threshold {
      filter          = "metric.type=\"run.googleapis.com/request_count\" resource.type=\"cloud_run_revision\" metric.labels.response_code_class=\"5xx\" resource.labels.service_name=\"${local.cloud_run_service_name}\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 10

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = []

  labels = merge(
    local.common_labels,
    {
      "alert-type" = "error-rate"
    }
  )
}

# Alert: Cloud SQL Connection Pool High Utilization
resource "google_monitoring_alert_policy" "cloud_sql_connections" {
  display_name = "${local.resource_prefix}-cloud-sql-connections"
  combiner     = "OR"

  conditions {
    display_name = "Cloud SQL connection pool utilization"

    condition_threshold {
      filter          = "metric.type=\"cloudsql.googleapis.com/database/network/connections\" resource.type=\"cloudsql_database\" resource.labels.database_id=\"${var.project_id}:${local.cloud_sql_instance_name}\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 200 # 80% of 240 max connections

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = []

  labels = merge(
    local.common_labels,
    {
      "alert-type" = "connection-pool"
    }
  )
}

# ============================================================================
# Outputs
# ============================================================================

output "monitoring_resources" {
  description = "Monitoring and logging resources"
  value = {
    dashboard = {
      id   = google_monitoring_dashboard.order_processing.dashboard_json
      name = google_monitoring_dashboard.order_processing.dashboard_json
    }
    alert_policies = {
      dlq_messages          = google_monitoring_alert_policy.dlq_messages.name
      cloud_run_error_rate  = google_monitoring_alert_policy.cloud_run_error_rate.name
      cloud_sql_connections = google_monitoring_alert_policy.cloud_sql_connections.name
    }
  }
}
