output "rds_endpoint" {
  description = "RDS database endpoint (address:port)"
  value       = aws_db_instance.orders.endpoint
  sensitive   = false
}

output "rds_address" {
  description = "RDS database address (hostname)"
  value       = aws_db_instance.orders.address
  sensitive   = false
}

output "rds_port" {
  description = "RDS database port"
  value       = aws_db_instance.orders.port
  sensitive   = false
}

output "database_name" {
  description = "Initial database name"
  value       = aws_db_instance.orders.db_name
  sensitive   = false
}

output "database_username" {
  description = "Database master username"
  value       = var.db_username
  sensitive   = true
}

output "rds_security_group_id" {
  description = "Security group ID for RDS instance"
  value       = aws_security_group.rds.id
  sensitive   = false
}

output "db_subnet_group_name" {
  description = "RDS DB subnet group name"
  value       = aws_db_subnet_group.orders.name
  sensitive   = false
}

output "secrets_manager_secret_arn" {
  description = "ARN of Secrets Manager secret containing database credentials"
  value       = aws_secretsmanager_secret.db_password.arn
  sensitive   = false
}

output "vpc_id" {
  description = "VPC ID for infrastructure"
  value       = aws_vpc.orders.id
  sensitive   = false
}

output "database_subnet_1_id" {
  description = "Primary database subnet ID"
  value       = aws_subnet.database_primary.id
  sensitive   = false
}

output "database_subnet_2_id" {
  description = "Secondary database subnet ID"
  value       = aws_subnet.database_secondary.id
  sensitive   = false
}

output "rds_arn" {
  description = "ARN of the RDS database instance"
  value       = aws_db_instance.orders.arn
  sensitive   = false
}

output "rds_instance_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.orders.id
  sensitive   = false
}

output "terraform_iam_role_arn" {
  description = "ARN of IAM role for Terraform execution (for CI/CD)"
  value       = try(aws_iam_role.terraform_executor.arn, "Not created")
  sensitive   = false
}

output "application_iam_role_arn" {
  description = "ARN of IAM role for application servers"
  value       = try(aws_iam_role.application.arn, "Not created")
  sensitive   = false
}

output "connection_string_template" {
  description = "Template for database connection string (fill in password)"
  value       = "postgresql://${var.db_username}:{password}@${aws_db_instance.orders.address}:${aws_db_instance.orders.port}/${aws_db_instance.orders.db_name}"
  sensitive   = true
}

output "environment" {
  description = "Environment name"
  value       = var.environment
  sensitive   = false
}

output "multi_az_enabled" {
  description = "Whether Multi-AZ is enabled for high availability"
  value       = aws_db_instance.orders.multi_az
  sensitive   = false
}

output "backup_retention_days" {
  description = "Number of backup retention days"
  value       = aws_db_instance.orders.backup_retention_period
  sensitive   = false
}

output "backup_window" {
  description = "Preferred backup window"
  value       = aws_db_instance.orders.backup_window
  sensitive   = false
}
