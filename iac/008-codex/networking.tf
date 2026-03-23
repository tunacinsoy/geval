resource "google_compute_network" "private" {
  name                    = "order-events-network"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"

  labels = local.default_labels
}

resource "google_compute_subnetwork" "private" {
  name                     = "order-events-subnet"
  ip_cidr_range            = "10.20.0.0/16"
  region                   = var.region
  network                  = google_compute_network.private.id
  private_ip_google_access = true
  log_config {
    aggregation_interval = "INTERVAL_5_MIN"
    enable               = true
  }
  secondary_ip_range {
    range_name    = "cloudsql-range"
    ip_cidr_range = "10.30.0.0/24"
  }
  labels = local.default_labels
}

resource "google_compute_global_address" "private_services" {
  name          = "order-events-private-services"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.private.id
}

resource "google_service_networking_connection" "private" {
  network                 = google_compute_network.private.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_services.name]
}

resource "google_vpc_access_connector" "cloud_run" {
  name           = "order-events-connector"
  region         = var.region
  network        = google_compute_network.private.name
  ip_cidr_range  = "10.22.0.0/28"
  project        = var.project_id
  min_throughput = 200
  max_throughput = 300
  labels         = local.default_labels
}

resource "google_compute_firewall" "cloud_run_to_cloud_sql" {
  name    = "allow-cloud-run-to-cloud-sql"
  network = google_compute_network.private.id

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_ranges = [google_vpc_access_connector.cloud_run.ip_cidr_range]
  direction     = "INGRESS"
  target_tags   = ["cloud-sql"]
}
