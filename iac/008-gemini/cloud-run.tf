resource "google_cloud_run_v2_service" "order_processing_service" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  template {
    scaling {
      min_instance_count = 0
      max_instance_count = 10
    }

    containers {
      image = var.cloud_run_image
    }
    
    service_account = google_service_account.order_processing_sa.email
  }

  ingress = "INGRESS_TRAFFIC_INTERNAL_ONLY"
}

# Allow Pub/Sub to invoke the Cloud Run service
resource "google_cloud_run_service_iam_member" "pubsub_invoker" {
  location = google_cloud_run_v2_service.order_processing_service.location
  project  = google_cloud_run_v2_service.order_processing_service.project
  service  = google_cloud_run_v2_service.order_processing_service.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

data "google_project" "project" {}
