# ============================================================================
# Cloud SQL Instance using terraform-google-modules
# ============================================================================

module "cloud_sql" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "~> 15.0"

  project_id = var.project_id
  name       = local.cloud_sql_instance_name
  region     = var.region
  tier       = var.cloud_sql_tier

  database_version  = "POSTGRES_${var.cloud_sql_version}"
  availability_type = var.enable_ha ? "REGIONAL" : "ZONAL"

  # Storage
  allocated_storage = var.cloud_sql_storage_gb
  enable_default_db = false

  # Backups
  backup_configuration = {
    enabled            = true
    binary_log_enabled = false
    backup_retention_settings = {
      retained_backups = 30
      retention_unit   = "COUNT"
    }
    location                       = var.region
    point_in_time_recovery_enabled = true
  }

  # Networking - Private IP
  enable_public_ip           = false
  enable_private_path_import = true

  # Database flags
  database_flags = [
    {
      name  = "log_connections"
      value = "on"
    },
    {
      name  = "log_disconnections"
      value = "on"
    },
    {
      name  = "log_statement"
      value = "all"
    },
    {
      name  = "log_duration"
      value = "on"
    }
  ]

  # Encryption
  encryption_key_name = null # Use Google-managed encryption key

  # Labels
  labels = merge(
    local.common_labels,
    {
      "database-engine" = "postgresql"
    }
  )

  # Database
  additional_databases = [
    {
      name = local.cloud_sql_database_name
    }
  ]

  # Users
  additional_users = [
    {
      name                = "order_processing"
      password            = random_password.cloud_sql_password.result
      password_valid_time = "3600s"
    }
  ]

  depends_on = [random_password.cloud_sql_password]
}

# ============================================================================
# Cloud SQL Database
# ============================================================================

resource "google_sql_database" "order_processing" {
  name      = local.cloud_sql_database_name
  instance  = module.cloud_sql.instance_name
  charset   = "UTF8"
  collation = "en_US.UTF8"
}

# ============================================================================
# Cloud Storage Buckets
# ============================================================================

# Terraform State Bucket
resource "google_storage_bucket" "terraform_state" {
  project  = var.project_id
  name     = local.terraform_state_bucket
  location = var.region

  versioning {
    enabled = true
  }

  encryption {
    default_kms_key_name = null # Use Google-managed encryption
  }

  labels = merge(
    local.common_labels,
    {
      "bucket-type" = "terraform-state"
    }
  )

  uniform_bucket_level_access = true

  lifecycle {
    prevent_destroy = true
  }
}

# Prevent accidental deletion of state bucket via bucket policy
resource "google_storage_bucket_iam_member" "terraform_state_access" {
  bucket = google_storage_bucket.terraform_state.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.terraform_sa.email}"
}

# Archive Bucket for Old Pub/Sub Messages
resource "google_storage_bucket" "archive" {
  project  = var.project_id
  name     = local.archive_bucket_name
  location = var.region

  versioning {
    enabled = true
  }

  encryption {
    default_kms_key_name = null # Use Google-managed encryption
  }

  labels = merge(
    local.common_labels,
    {
      "bucket-type" = "message-archive"
    }
  )

  uniform_bucket_level_access = true

  # Lifecycle rule: retain 90 days, then delete
  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }

  # Lifecycle rule: transition to Nearline after 30 days
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
}

# ============================================================================
# Cloud SQL Auth Proxy Configuration
# ============================================================================

resource "google_service_account" "cloud_sql_auth_proxy_sa" {
  account_id   = "${local.resource_prefix}-auth-proxy-sa"
  display_name = "Cloud SQL Auth Proxy Service Account"
  description  = "Service account for Cloud SQL Auth Proxy connectivity"
}

resource "google_project_iam_member" "auth_proxy_cloud_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloud_sql_auth_proxy_sa.email}"
}

# ============================================================================
# Outputs
# ============================================================================

output "cloud_sql_details" {
  description = "Cloud SQL instance details"
  value = {
    instance_name     = module.cloud_sql.instance_name
    connection_name   = module.cloud_sql.instance_connection_name
    private_ip        = module.cloud_sql.instance_private_ip
    database_name     = google_sql_database.order_processing.name
    version           = var.cloud_sql_version
    tier              = var.cloud_sql_tier
    high_availability = var.enable_ha
  }
}

output "cloud_storage_buckets" {
  description = "Cloud Storage bucket details"
  value = {
    terraform_state = {
      name       = google_storage_bucket.terraform_state.name
      location   = google_storage_bucket.terraform_state.location
      versioning = true
    }
    archive = {
      name      = google_storage_bucket.archive.name
      location  = google_storage_bucket.archive.location
      retention = 90
    }
  }
}
