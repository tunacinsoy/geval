resource "aws_cloudtrail" "hr_trail" {
  name                          = "hr-document-trail"
  s3_bucket_name                = aws_s3_bucket.audit_logs.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  event_selector {
    read_write_type           = "All"
    include_management_events = true
    data_resources {
      type   = "AWS::S3::Object"
      values = [aws_s3_bucket.hr_documents.arn]
    }
  }
}

resource "aws_cloudwatch_log_group" "hr_app" {
  name              = "/hr/portal"
  retention_in_days = 30
  tags = {
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "audit" {
  name              = "/hr/audit"
  retention_in_days = 90
}
