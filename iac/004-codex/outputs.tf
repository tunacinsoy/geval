output "database_endpoint" {
  value       = module.primary_db.db_instance_endpoint
  description = "Primary PostgreSQL endpoint"
}

output "db_instance_identifiers" {
  value       = module.primary_db.db_instance_identifiers
  description = "Identifiers for all instances (primary + replicas)"
}

output "import_bucket_name" {
  value       = aws_s3_bucket.import_bucket.id
  description = "Bucket for spreadsheet imports"
}

output "export_bucket_name" {
  value       = aws_s3_bucket.export_bucket.id
  description = "Bucket for exports and archive files"
}

output "audit_bucket_name" {
  value       = aws_s3_bucket.audit_bucket.id
  description = "Bucket storing audit logs and snapshots"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.ingestion_cluster.name
  description = "ECS cluster supporting ingestion tasks"
}

output "lambda_function_name" {
  value       = aws_lambda_function.validation_function.function_name
  description = "Lambda used for lightweight schema guards"
}
