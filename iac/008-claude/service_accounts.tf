# Cloud Run Service Account
resource "google_service_account" "cloud_run_sa" {
  account_id   = local.cloud_run_sa_name
  display_name = "Cloud Run Service Account for Order Processing"
  description  = "Service account for Cloud Run order processing service with Pub/Sub subscriber and Cloud SQL client permissions"
}

# Analytics Service Account
resource "google_service_account" "analytics_sa" {
  account_id   = local.analytics_sa_name
  display_name = "Analytics Service Account for Order Events"
  description  = "Service account for analytics pull subscription consumer"
}

# Terraform CI/CD Service Account (optional, for CI/CD deployments)
resource "google_service_account" "terraform_sa" {
  account_id   = "${local.resource_prefix}-terraform-sa"
  display_name = "Terraform CI/CD Service Account"
  description  = "Service account for CI/CD Terraform deployments"
}

# ============================================================================
# Cloud Run Service Account - IAM Role Bindings
# ============================================================================

# Pub/Sub Subscriber role
resource "google_project_iam_member" "cloud_run_pubsub_subscriber" {
  project = var.project_id
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

# Cloud SQL Client role (for Auth Proxy connections)
resource "google_project_iam_member" "cloud_run_cloud_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

# Logging Write role (for application logs)
resource "google_project_iam_member" "cloud_run_logging_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

# Monitoring Metric Writer role (for custom metrics)
resource "google_project_iam_member" "cloud_run_monitoring_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

# Secret Manager Accessor role (for database password)
resource "google_project_iam_member" "cloud_run_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

# ============================================================================
# Analytics Service Account - IAM Role Bindings
# ============================================================================

# Pub/Sub Subscriber role (for pull subscription)
resource "google_project_iam_member" "analytics_pubsub_subscriber" {
  project = var.project_id
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.analytics_sa.email}"
}

# Storage Object Viewer role (for archive bucket)
resource "google_project_iam_member" "analytics_storage_viewer" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.analytics_sa.email}"
}

# Logging Write role (for analytics service logs)
resource "google_project_iam_member" "analytics_logging_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.analytics_sa.email}"
}

# ============================================================================
# Cloud Run Service Account - Grant Pub/Sub to invoke Cloud Run
# ============================================================================

resource "google_cloud_run_service_iam_member" "pubsub_invoke_cloud_run" {
  service  = google_cloud_run_service.order_processor.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloud-pubsub.iam.gserviceaccount.com"

  depends_on = [google_cloud_run_service.order_processor]
}

# ============================================================================
# Terraform CI/CD Service Account - IAM Role Bindings
# ============================================================================

# Editor role (for infrastructure provisioning in dev/staging)
resource "google_project_iam_member" "terraform_editor" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.terraform_sa.email}"
}

# Get current project data for Pub/Sub service account
data "google_project" "project" {
  project_id = var.project_id
}
