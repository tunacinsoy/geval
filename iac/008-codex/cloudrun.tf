resource "google_cloud_run_service" "order_processor" {
  name     = var.cloud_run_service_name
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.order_processor.email
      containers {
        image = var.cloud_run_container_image
        env {
          name  = "CLOUD_SQL_CONNECTION_NAME"
          value = google_sql_database_instance.order_processor.connection_name
        }
        env {
          name  = "DB_USER"
          value = var.db_username
        }
        env {
          name  = "DB_PASSWORD_SECRET"
          value = google_secret_manager_secret.db_password.secret_id
        }
        env {
          name  = "PUBSUB_TOPIC"
          value = google_pubsub_topic.order_events.name
        }
        env {
          name  = "PUBSUB_PULL_SUBSCRIPTION"
          value = google_pubsub_subscription.analytics_pull.name
        }
        env {
          name  = "CLOUD_RUN_MIN_INSTANCES"
          value = tostring(var.cloud_run_min_instances)
        }
        env {
          name  = "CLOUD_RUN_MAX_INSTANCES"
          value = tostring(var.cloud_run_max_instances)
        }
        env {
          name  = "CLOUD_RUN_TIMEOUT"
          value = tostring(var.cloud_run_timeout_seconds)
        }
        env {
          name  = "CLOUD_RUN_CONCURRENCY"
          value = tostring(var.cloud_run_concurrency)
        }
        resources {
          limits = {
            cpu    = tostring(var.cloud_run_cpu)
            memory = format("%dMi", var.cloud_run_memory)
          }
        }
        ports {
          container_port = 8080
        }
      }
      containers {
        name  = "auth-proxy"
        image = "gcr.io/cloudsql-docker/gce-proxy:1.33.6"
        args = [
          "/cloud_sql_proxy",
          "-instances=${google_sql_database_instance.order_processor.connection_name}=tcp:5432",
          "-credential_file=/secrets/cloudsql/admin-credentials.json"
        ]
        volume_mounts {
          name       = "cloudsql-creds"
          mount_path = "/secrets/cloudsql"
          read_only  = true
        }
      }
      volumes {
        name = "cloudsql-creds"
        secret {
          secret_name = google_secret_manager_secret.db_password.secret_id
          items {
            key  = "password"
            path = "admin-credentials.json"
          }
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = tostring(var.cloud_run_min_instances)
        "autoscaling.knative.dev/maxScale" = tostring(var.cloud_run_max_instances)
      }
      labels = local.default_labels
    }
  }

  traffics {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "invoker" {
  service  = google_cloud_run_service.order_processor.name
  location = google_cloud_run_service.order_processor.location
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.order_processor.email}"
}
