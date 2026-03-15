# RDS DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${local.resource_prefix}-db-subnet-group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.public.id]  # Include both subnets

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_prefix}-db-subnet-group"
    }
  )
}

# RDS PostgreSQL Instance with Standby Replica (same AZ)
resource "aws_db_instance" "main" {
  identifier     = "${local.resource_prefix}-postgres"
  engine         = local.db_engine
  engine_version = local.db_engine_version

  # Instance sizing
  instance_class       = local.db_instance_type
  allocated_storage    = local.db_allocated_storage
  storage_type         = "gp3"
  storage_encrypted    = true
  publicly_accessible  = false

  # Credentials (MUST be set via TF_VAR_db_master_password environment variable)
  username = var.db_master_username
  password = var.db_master_password

  # Backup and maintenance
  backup_retention_period = local.db_backup_retention
  backup_window          = "03:00-04:00"
  maintenance_window     = "mon:04:00-mon:05:00"
  copy_tags_to_snapshot  = true

  # High Availability - Standby Replica in same AZ
  multi_az = false                                      # Single AZ for cost

  # Database configuration
  db_name                = local.db_name
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Performance and monitoring
  enabled_cloudwatch_logs_exports = ["postgresql"]
  monitoring_interval             = 0  # Can enable for additional monitoring (cost)
  performance_insights_enabled    = false

  # Encryption and security
  iam_database_authentication_enabled = false  # IAM auth optional

  # Skip final snapshot for test environment (data discarded)
  skip_final_snapshot       = true
  final_snapshot_identifier = null

  depends_on = [
    aws_security_group.rds
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_prefix}-postgres"
    }
  )

  lifecycle {
    ignore_changes = [password]  # Ignore password changes after creation
  }
}

# RDS Replica (Standby in same AZ) - Automatic Failover
resource "aws_db_instance" "replica" {
  identifier          = "${local.resource_prefix}-postgres-replica"
  replicate_source_db = aws_db_instance.main.identifier

  instance_class = local.db_instance_type

  # Automatic failover
  auto_minor_version_upgrade = false
  publicly_accessible        = false

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_prefix}-postgres-replica"
      Role = "Standby"
    }
  )

  depends_on = [aws_db_instance.main]
}

# Promote replica to standalone (manual operation if needed)
# resource "aws_db_instance_from_db_snapshot" "failover" {
#    conditional on manual failover
# }

# Outputs
output "rds_endpoint" {
  description = "RDS database endpoint (host:port)"
  value       = aws_db_instance.main.endpoint
}

output "rds_address" {
  description = "RDS database address (hostname only)"
  value       = aws_db_instance.main.address
}

output "rds_port" {
  description = "RDS database port"
  value       = aws_db_instance.main.port
}

output "rds_database_name" {
  description = "RDS database name"
  value       = aws_db_instance.main.db_name
}

output "rds_username" {
  description = "RDS master username"
  value       = aws_db_instance.main.username
}

output "rds_replica_endpoint" {
  description = "RDS replica (standby) endpoint"
  value       = aws_db_instance.replica.endpoint
}

output "rds_connection_string" {
  description = "PostgreSQL connection string template"
  value       = "postgresql://${aws_db_instance.main.username}:PASSWORD@${aws_db_instance.main.address}:${aws_db_instance.main.port}/${aws_db_instance.main.db_name}"
  sensitive   = true
}