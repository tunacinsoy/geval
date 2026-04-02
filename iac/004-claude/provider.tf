provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = "customer-orders-database"
      ManagedBy   = "terraform"
      Owner       = "platform-team"
      CreatedAt   = timestamp()
    }
  }
}

provider "postgresql" {
  host            = try(aws_db_instance.orders.address, "")
  port            = try(aws_db_instance.orders.port, 5432)
  username        = var.db_username
  password        = random_password.db_password.result
  database        = var.database_name
  sslmode         = "require"
  connect_timeout = 15
}
