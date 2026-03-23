variable "project_id" {
  description = "The GCP project ID to deploy resources into."
  type        = string
}

variable "region" {
  description = "The GCP region to deploy resources into."
  type        = string
  default     = "us-central1"
}

variable "gcs_bucket_for_tfstate" {
  description = "The name of the GCS bucket for Terraform state."
  type        = string
}

variable "service_name" {
  description = "The name of the Cloud Run service."
  type        = string
  default     = "order-processing-service"
}

variable "cloud_run_image" {
  description = "The container image to deploy to Cloud Run."
  type        = string
}
