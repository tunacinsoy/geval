terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.40"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.40"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region

  default_labels {
    environment  = var.environment
    component    = "order-processing"
    managed_by   = "terraform"
    created_date = formatdate("YYYY-MM-DD", timestamp())
  }
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}
