variable "project_id" {
  type        = string
  description = "GCP project that hosts the messaging and compute infrastructure"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "Region where compute, networking, and storage resources live"
}

variable "zone" {
  type        = string
  default     = "us-central1-a"
  description = "Primary availability zone for zonal resources"
}

variable "target_environment" {
  type        = string
  default     = "dev"
  description = "Environment label used for tags/labels/workspaces"
}

variable "topic_name" {
  type    = string
  default = "order-events"
}

variable "schema_id" {
  type    = string
  default = "order-events-schema"
}

variable "schema_definition_file" {
  type    = string
  default = "iac/schemas/order-events.avsc"
}

variable "push_subscription_name" {
  type    = string
  default = "order-processing-push"
}

variable "pull_subscription_name" {
  type    = string
  default = "analytics-archival-pull"
}

variable "cloud_run_service_name" {
  type    = string
  default = "order-processor"
}

variable "cloud_run_container_image" {
  type    = string
  default = "gcr.io/google-samples/cloudrun-hello"
}

variable "cloud_sql_instance_name" {
  type    = string
  default = "order-processor-sql"
}

variable "cloud_sql_database_name" {
  type    = string
  default = "orders"
}

variable "cloud_sql_tier" {
  type    = string
  default = "db-custom-1-3840"
}

variable "analytics_dataset" {
  type    = string
  default = "order_events_archive"
}

variable "analytics_retention_days" {
  type    = number
  default = 30
}

variable "service_account_id" {
  type    = string
  default = "order-processor-sa"
}

variable "service_account_display_name" {
  type    = string
  default = "Order processing service account"
}

variable "cloud_run_min_instances" {
  type    = number
  default = 0
}

variable "cloud_run_max_instances" {
  type    = number
  default = 10
}

variable "cloud_run_concurrency" {
  type    = number
  default = 80
}

variable "cloud_run_cpu" {
  type    = number
  default = 2
}

variable "cloud_run_memory" {
  type    = number
  default = 2048
}

variable "cloud_run_timeout_seconds" {
  type    = number
  default = 60
}

variable "pubsub_ack_deadline_seconds" {
  type    = number
  default = 30
}

variable "pubsub_retention_duration_seconds" {
  type    = number
  default = 604800
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "tfc_organization" {
  type    = string
  default = "example-org"
}

variable "db_password_length" {
  type    = number
  default = 16
}

variable "db_username" {
  type    = string
  default = "orders_user"
}

locals {
  default_labels = merge({
    environment = var.target_environment
    service     = "order-events"
  }, var.labels)
}

data "local_file" "avro_schema" {
  filename = var.schema_definition_file
}

data "google_project" "current" {}
