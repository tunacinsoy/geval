output "db_instance_endpoint" {
  description = "The connection endpoint for the database."
  value       = aws_db_instance.main.endpoint
}

output "db_instance_name" {
  description = "The name of the database instance."
  value       = aws_db_instance.main.id
}
