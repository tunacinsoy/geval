locals {
  # Naming conventions
  resource_prefix = "order-processing-${var.environment}"

  pubsub_topic_name     = "order-events"
  pubsub_dlq_topic_name = "order-events-dlq"
  pubsub_push_sub_name  = "order-events-cloud-run"
  pubsub_pull_sub_name  = "order-events-analytics"

  cloud_run_service_name  = "${local.resource_prefix}-service"
  cloud_sql_instance_name = "${local.resource_prefix}-db"
  cloud_sql_database_name = "order_processing_db"

  terraform_state_bucket = "terraform-state-${var.project_id}"
  archive_bucket_name    = "order-events-archive-${var.project_id}"

  # Service accounts
  cloud_run_sa_name = "${local.resource_prefix}-cloud-run-sa"
  analytics_sa_name = "${local.resource_prefix}-analytics-sa"

  # Labels for all resources
  common_labels = {
    environment = var.environment
    component   = "order-processing"
    managed_by  = "terraform"
  }

  # Environment-specific configurations
  env_config = {
    dev = {
      cloud_sql_tier    = "db-f1-micro"
      cloud_sql_storage = 10
      cloud_run_min     = 0
      cloud_run_max     = 2
      enable_ha         = false
      log_retention     = 7
      backup_retention  = 7
    }
    staging = {
      cloud_sql_tier    = "db-n1-standard-1"
      cloud_sql_storage = 50
      cloud_run_min     = 0
      cloud_run_max     = 5
      enable_ha         = false
      log_retention     = 30
      backup_retention  = 7
    }
    prod = {
      cloud_sql_tier    = "db-n1-standard-4"
      cloud_sql_storage = 100
      cloud_run_min     = 1
      cloud_run_max     = 10
      enable_ha         = true
      log_retention     = 90
      backup_retention  = 35
    }
  }

  current_env_config = local.env_config[var.environment]

  # Avro schema for order events
  avro_schema = jsonencode({
    type      = "record"
    name      = "OrderEvent"
    namespace = "com.example.order"
    fields = [
      {
        name = "order_id"
        type = "string"
      },
      {
        name = "customer_id"
        type = "string"
      },
      {
        name = "order_total"
        type = {
          type        = "bytes"
          logicalType = "decimal"
          precision   = 10
          scale       = 2
        }
      },
      {
        name = "timestamp"
        type = {
          type        = "long"
          logicalType = "timestamp-millis"
        }
      },
      {
        name = "items"
        type = {
          type = "array"
          items = {
            type = "record"
            name = "LineItem"
            fields = [
              {
                name = "sku"
                type = "string"
              },
              {
                name = "quantity"
                type = "int"
              },
              {
                name = "price"
                type = {
                  type        = "bytes"
                  logicalType = "decimal"
                  precision   = 10
                  scale       = 2
                }
              }
            ]
          }
        }
      },
      {
        name = "payment_method"
        type = {
          type    = "enum"
          name    = "PaymentMethod"
          symbols = ["credit_card", "paypal", "bank_transfer"]
        }
      },
      {
        name = "shipping_address"
        type = {
          type = "record"
          name = "Address"
          fields = [
            {
              name = "street"
              type = "string"
            },
            {
              name = "city"
              type = "string"
            },
            {
              name = "region"
              type = "string"
            },
            {
              name = "postal_code"
              type = "string"
            },
            {
              name = "country"
              type = "string"
            }
          ]
        }
      },
      {
        name = "billing_address"
        type = "Address"
      },
      {
        name = "order_status"
        type = {
          type    = "enum"
          name    = "OrderStatus"
          symbols = ["pending", "confirmed", "processing", "shipped", "delivered", "cancelled"]
        }
      }
    ]
  })
}
