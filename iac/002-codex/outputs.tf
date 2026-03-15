output "alb_dns" {
  description = "Internal DNS name for the HR document ALB"
  value       = aws_lb.hr_alb.dns_name
}

output "document_bucket" {
  description = "Primary encrypted S3 bucket for HR documents"
  value       = aws_s3_bucket.hr_documents.bucket
}

output "log_bucket" {
  description = "Bucket capturing audit trails and logs"
  value       = aws_s3_bucket.audit_logs.bucket
}

output "private_link_service_name" {
  description = "PrivateLink service name for the ALB"
  value       = aws_vpc_endpoint_service.hr_portal.arn
}
