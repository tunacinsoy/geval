# IAM Service Account for the Cloud Run service
resource "google_service_account" "order_processing_sa" {
  account_id   = "order-processing-sa"
  display_name = "Order Processing Service Account"
  project      = var.project_id
}

# Grant the 'roles/pubsub.subscriber' role to the service account
resource "google_project_iam_member" "pubsub_subscriber" {
  project = var.project_id
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.order_processing_sa.email}"
}

# Grant the 'roles/cloudsql.client' role to the service account
resource "google_project_iam_member" "cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.order_processing_sa.email}"
}
