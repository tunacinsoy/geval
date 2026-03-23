resource "google_sql_database_instance" "order_processor" {
  name             = var.cloud_sql_instance_name
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier              = var.cloud_sql_tier
    availability_type = "REGIONAL"
    data_disk_type    = "PD_SSD"
    data_disk_size_gb = 20

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private.self_link
    }
  }

  deletion_protection = false
}

resource "google_sql_database" "orders" {
  name     = var.cloud_sql_database_name
  instance = google_sql_database_instance.order_processor.name
}

resource "google_sql_user" "orders_user" {
  name     = var.db_username
  instance = google_sql_database_instance.order_processor.name
  password = random_password.db_password.result
}
