variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

# Cloud Run Configuration
variable "cloud_run_min_instances" {
  description = "Minimum number of Cloud Run instances (0 for dev/staging)"
  type        = number
  validation {
    condition     = var.cloud_run_min_instances >= 0
    error_message = "Min instances must be >= 0."
  }
}

variable "cloud_run_max_instances" {
  description = "Maximum number of Cloud Run instances"
  type        = number
  validation {
    condition     = var.cloud_run_max_instances <= 10
    error_message = "Max instances must be <= 10."
  }
}

variable "cloud_run_memory" {
  description = "Cloud Run memory per instance (MB)"
  type        = string
  default     = "512Mi"
}

variable "cloud_run_cpu" {
  description = "Cloud Run CPU per instance"
  type        = string
  default     = "0.5"
}

variable "cloud_run_timeout_seconds" {
  description = "Cloud Run request timeout in seconds"
  type        = number
  default     = 60
}

variable "cloud_run_concurrency" {
  description = "Max concurrent requests per Cloud Run instance"
  type        = number
  default     = 200
}

# Cloud SQL Configuration
variable "cloud_sql_tier" {
  description = "Cloud SQL instance tier (machine type)"
  type        = string
  validation {
    condition     = contains(["db-f1-micro", "db-n1-standard-1", "db-n1-standard-4"], var.cloud_sql_tier)
    error_message = "Cloud SQL tier must be db-f1-micro (dev), db-n1-standard-1 (staging), or db-n1-standard-4 (prod)."
  }
}

variable "cloud_sql_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "15"
}

variable "cloud_sql_storage_gb" {
  description = "Cloud SQL storage in GB"
  type        = number
  default     = 10
}

variable "enable_ha" {
  description = "Enable Cloud SQL High Availability (prod only)"
  type        = bool
  default     = false
}

variable "enable_vpc" {
  description = "Enable VPC for network isolation (prod only)"
  type        = bool
  default     = false
}

# Pub/Sub Configuration
variable "pubsub_message_retention_days" {
  description = "Pub/Sub message retention in days"
  type        = number
  default     = 7
}

variable "pubsub_dead_letter_retention_days" {
  description = "Dead-letter queue message retention in days"
  type        = number
  default     = 7
}

variable "pubsub_max_delivery_attempts" {
  description = "Maximum delivery attempts before routing to DLQ"
  type        = number
  default     = 3
}

# Logging Configuration
variable "log_retention_days" {
  description = "Cloud Logging retention in days"
  type        = number
  default     = 7
}

variable "log_level" {
  description = "Application log level"
  type        = string
  default     = "INFO"
}
