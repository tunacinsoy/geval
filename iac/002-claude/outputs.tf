# Terraform Outputs for Important Resource Identifiers

output "documents_bucket_name" {
  description = "Name of the S3 bucket for HR documents"
  value       = aws_s3_bucket.documents.id
}

output "documents_bucket_arn" {
  description = "ARN of the S3 documents bucket"
  value       = aws_s3_bucket.documents.arn
}

output "documents_bucket_region" {
  description = "AWS region where documents bucket is located"
  value       = aws_s3_bucket.documents.region
}

output "documents_bucket_versioning_enabled" {
  description = "Whether versioning is enabled on the documents bucket"
  value       = aws_s3_bucket_versioning.documents.versioning_configuration[0].status
}

output "replica_bucket_name" {
  description = "Name of the replica S3 bucket for disaster recovery"
  value       = aws_s3_bucket.documents_replica.id
}

output "replica_bucket_arn" {
  description = "ARN of the replica S3 bucket"
  value       = aws_s3_bucket.documents_replica.arn
}

output "replication_enabled" {
  description = "Whether cross-region replication is enabled"
  value       = var.cross_region_replication_enabled
}

output "kms_key_id" {
  description = "ID of the KMS key used for S3 bucket encryption"
  value       = aws_kms_key.s3_key.id
  sensitive   = true
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for S3 bucket encryption"
  value       = aws_kms_key.s3_key.arn
}

output "kms_key_alias" {
  description = "Alias of the KMS key for easier reference"
  value       = aws_kms_alias.s3_key.name
}

output "terraform_state_kms_key_arn" {
  description = "ARN of the KMS key used for Terraform state encryption"
  value       = aws_kms_key.terraform_state_key.arn
  sensitive   = true
}

output "hr_admin_role_arn" {
  description = "ARN of the HR Admin IAM role (requires MFA)"
  value       = aws_iam_role.hr_admin.arn
}

output "hr_admin_role_name" {
  description = "Name of the HR Admin IAM role"
  value       = aws_iam_role.hr_admin.name
}

output "hr_manager_role_arn" {
  description = "ARN of the HR Manager IAM role"
  value       = aws_iam_role.hr_manager.arn
}

output "hr_manager_role_name" {
  description = "Name of the HR Manager IAM role"
  value       = aws_iam_role.hr_manager.name
}

output "hr_staff_role_arn" {
  description = "ARN of the HR Staff IAM role"
  value       = aws_iam_role.hr_staff.arn
}

output "hr_staff_role_name" {
  description = "Name of the HR Staff IAM role"
  value       = aws_iam_role.hr_staff.name
}

output "s3_replication_role_arn" {
  description = "ARN of the IAM role used for S3 replication"
  value       = aws_iam_role.s3_replication.arn
}

output "logs_bucket_name" {
  description = "Name of the S3 bucket for access logs"
  value       = aws_s3_bucket.logs.id
}

output "logs_bucket_arn" {
  description = "ARN of the S3 logs bucket"
  value       = aws_s3_bucket.logs.arn
}

output "cloudtrail_logs_bucket_name" {
  description = "Name of the S3 bucket for CloudTrail logs"
  value       = aws_s3_bucket.cloudtrail_logs.id
}

output "cloudtrail_logs_bucket_arn" {
  description = "ARN of the CloudTrail logs bucket"
  value       = aws_s3_bucket.cloudtrail_logs.arn
}

output "cloudtrail_name" {
  description = "Name of the CloudTrail trail for API logging"
  value       = var.enable_cloudtrail_logging ? aws_cloudtrail.documents[0].name : null
}

output "cloudtrail_arn" {
  description = "ARN of the CloudTrail trail"
  value       = var.enable_cloudtrail_logging ? aws_cloudtrail.documents[0].arn : null
}

output "cloudwatch_log_group_name" {
  description = "Name of CloudWatch Log Group for CloudTrail events"
  value       = var.enable_cloudtrail_logging ? aws_cloudwatch_log_group.cloudtrail[0].name : null
}

output "dashboard_name" {
  description = "Name of the CloudWatch dashboard for monitoring"
  value       = aws_cloudwatch_dashboard.hr_documents.dashboard_name
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for infrastructure alerts"
  value       = aws_sns_topic.infrastructure_alerts.arn
}

output "sns_topic_name" {
  description = "Name of the SNS topic for alerts"
  value       = aws_sns_topic.infrastructure_alerts.name
}

output "environment" {
  description = "Environment name (prod or dev)"
  value       = var.environment
}

output "aws_region" {
  description = "Primary AWS region"
  value       = var.aws_region
}

output "aws_region_replica" {
  description = "Replica AWS region for disaster recovery"
  value       = var.aws_region_replica
}

output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
  sensitive   = true
}

output "implementation_summary" {
  description = "Summary of HR Document Storage infrastructure"
  value = {
    infrastructure_type = "Secure HR Document Storage (S3 + IAM + KMS)"
    primary_region      = var.aws_region
    replica_region      = var.aws_region_replica
    encryption          = "AES-256 with KMS customer-managed key"
    versioning          = var.versioning_enabled ? "Enabled" : "Disabled"
    mfa_delete          = var.mfa_delete_enabled ? "Enabled" : "Disabled"
    replication         = var.cross_region_replication_enabled ? "Enabled" : "Disabled"
    cloudtrail_logging  = var.enable_cloudtrail_logging ? "Enabled" : "Disabled"
    compliance          = "GDPR Article 32 + SOC 2 Type II"
    roles               = ["HR-Admin (MFA required)", "HR-Manager", "HR-Staff (read-only)"]
    backup_retention    = "${var.backup_retention_days} days"
    document_retention  = "${var.lifecycle_expiration_years} years"
  }
}
