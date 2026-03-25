resource "aws_secretsmanager_secret" "database_credentials" {
  name = "customer-orders-db-${var.environment}"
  description = "Credentials for the customer order database"
  tags = merge(var.common_tags, {
    Environment = var.environment
  })
}

resource "aws_secretsmanager_secret_version" "database_credentials" {
  secret_id     = aws_secretsmanager_secret.database_credentials.id
  secret_string = jsonencode({
    username = var.db_master_username
    password = random_password.db_master.result
    host     = module.primary_db.db_instance_endpoint
    port     = module.primary_db.db_instance_port
    engine   = module.primary_db.engine
  })
}
