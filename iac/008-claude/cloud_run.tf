# ============================================================================
# Cloud Run Service for Order Processing
# ============================================================================

resource "google_cloud_run_service" "order_processor" {
  name     = local.cloud_run_service_name
  location = var.region
  project  = var.project_id

  template {
    spec {
      service_account_name = google_service_account.cloud_run_sa.email

      containers {
        image = "gcr.io/cloudrun/hello" # Placeholder - replace with actual image

        ports {
          container_port = 8080
        }

        resources {
          limits = {
            cpu    = var.cloud_run_cpu
            memory = var.cloud_run_memory
          }
        }

        # Environment variables
        env {
          name  = "CLOUD_SQL_INSTANCE"
          value = module.cloud_sql.instance_connection_name
        }

        env {
          name  = "PUBSUB_TOPIC"
          value = module.pubsub_topic.topic
        }

        env {
          name  = "ENVIRONMENT"
          value = var.environment
        }

        env {
          name  = "LOG_LEVEL"
          value = var.log_level
        }

        # Secret reference for database password
        env {
          name = "DATABASE_PASSWORD"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.cloud_sql_password.secret_id
              key  = "latest"
            }
          }
        }
      }

      # Timeout for request
      timeout_seconds = var.cloud_run_timeout_seconds

      # Service configuration
      concurrency = var.cloud_run_concurrency
    }

    # Auto-scaling configuration
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = var.cloud_run_min_instances
        "autoscaling.knative.dev/maxScale" = var.cloud_run_max_instances
      }
    }
  }

  # Traffic configuration
  traffic {
    percent         = 100
    latest_revision = true
  }

  labels = merge(
    local.common_labels,
    {
      "service-type" = "order-processor"
    }
  )

  depends_on = [
    google_service_account.cloud_run_sa,
    module.pubsub_topic,
    module.cloud_sql,
    google_secret_manager_secret_version.cloud_sql_password
  ]
}

# ============================================================================
# Cloud Run Service Configuration - Ingress
# ============================================================================

resource "google_cloud_run_service_iam_member" "cloud_run_allow_unauthenticated" {
  service  = google_cloud_run_service.order_processor.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloud-pubsub.iam.gserviceaccount.com"
}

# ============================================================================
# Cloud Run Custom Domain (Optional)
# ============================================================================

# NOTE: Custom domain mapping requires DNS setup outside of Terraform
# This is a placeholder for future custom domain configuration
# resource "google_cloud_run_domain_mapping" "custom_domain" {
#   name     = "order-processing.example.com"
#   location = var.region
#   service_name = google_cloud_run_service.order_processor.name
# }

# ============================================================================
# Cloud Run Revision Auto-Scaling Policy
# ============================================================================

resource "google_monitoring_metric_descriptor" "cloud_run_request_latency" {
  type         = "custom.googleapis.com/cloud_run/request_latency"
  metric_kind  = "GAUGE"
  value_type   = "DOUBLE"
  unit         = "ms"
  display_name = "Cloud Run Request Latency"
  description  = "Request latency for Cloud Run order processor service"

  labels {
    key         = "service"
    value_type  = "STRING"
    description = "Cloud Run service name"
  }

  depends_on = [google_cloud_run_service.order_processor]
}

# ============================================================================
# Outputs
# ============================================================================

output "cloud_run_service" {
  description = "Cloud Run service details"
  value = {
    name              = google_cloud_run_service.order_processor.name
    url               = google_cloud_run_service.order_processor.status[0].url
    location          = var.region
    service_account   = google_service_account.cloud_run_sa.email
    min_instances     = var.cloud_run_min_instances
    max_instances     = var.cloud_run_max_instances
    memory            = var.cloud_run_memory
    cpu               = var.cloud_run_cpu
    timeout_seconds   = var.cloud_run_timeout_seconds
    concurrency_limit = var.cloud_run_concurrency
  }
}
