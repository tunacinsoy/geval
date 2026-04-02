# RDS PostgreSQL Database Infrastructure

# Generate secure random password for database master user
resource "random_password" "db_password" {
  length  = var.password_length
  special = true
  # Exclude characters that might cause issues in PostgreSQL connection strings
  override_special = "!#$%&*()-_=+[]{}<>?"
}

# PostgreSQL parameter group for audit logging
resource "aws_db_parameter_group" "orders" {
  name_prefix = "orders-postgres15-${var.environment}-"
  family      = "postgres15"
  description = "PostgreSQL 15 parameter group for orders database - ${var.environment}"

  # Enable audit logging
  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  tags = merge(
    var.tags,
    {
      Name = "orders-pg-param-group-${var.environment}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# RDS Database Instance for PostgreSQL
resource "aws_db_instance" "orders" {
  # Identifier configuration
  identifier_prefix = "orders-${var.environment}-"
  db_name           = var.database_name
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = var.instance_type
  allocated_storage = var.storage_size
  storage_type      = "gp3"
  storage_encrypted = true

  # High Availability and Failover
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_days
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  copy_tags_to_snapshot   = true

  # Credentials - stored securely in Secrets Manager
  username = var.db_username
  password = random_password.db_password.result

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.orders.name
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Parameter group with audit logging
  parameter_group_name = aws_db_parameter_group.orders.name

  # Monitoring and logging
  enabled_cloudwatch_logs_exports = [
    "postgresql"
  ]
  monitoring_interval = var.monitoring_interval > 0 ? var.monitoring_interval : 0
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn

  # Deletion protection
  deletion_protection = var.enable_deletion_protection

  # Skip final snapshot for dev, keep for staging/prod
  skip_final_snapshot       = var.environment == "dev" ? true : false
  final_snapshot_identifier = var.environment != "dev" ? "orders-${var.environment}-${formatdate("YYYY-MM-DD-hhmm", timestamp())}" : null

  depends_on = [
    aws_db_subnet_group.orders,
    aws_security_group.rds,
    aws_iam_role.rds_monitoring
  ]

  tags = merge(
    var.tags,
    {
      Name = "orders-db-${var.environment}"
    }
  )

  lifecycle {
    ignore_changes = [password] # Don't reset password on apply if it changes in Secrets Manager
  }
}
