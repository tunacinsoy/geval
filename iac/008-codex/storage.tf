resource "google_bigquery_dataset" "analytics" {
  dataset_id                  = var.analytics_dataset
  location                    = var.region
  default_table_expiration_ms = var.analytics_retention_days * 24 * 60 * 60 * 1000
  labels                      = local.default_labels
}

resource "google_bigquery_table" "events" {
  dataset_id = google_bigquery_dataset.analytics.dataset_id
  table_id   = "events"
  time_partitioning {
    type          = "DAY"
    expiration_ms = var.analytics_retention_days * 24 * 60 * 60 * 1000
  }
  clustering {
    fields = ["order_id", "created_at"]
  }
}

resource "google_storage_bucket" "analytics_archive" {
  name                        = "order-events-archive-${var.target_environment}-${var.region}"
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
  retention_policy {
    retention_period = var.analytics_retention_days * 24 * 60 * 60
  }
  lifecycle_rule {
    action {
      type          = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
    condition {
      age = 30
    }
  }
  labels = local.default_labels
}
