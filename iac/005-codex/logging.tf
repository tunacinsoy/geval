resource "aws_cloudtrail" "global" {
  name                          = "global-image-delivery-trail"
  s3_bucket_name                = aws_s3_bucket.logging.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  event_selector {
    read_write_type           = "All"
    include_management_events = true
    data_resource {
      type = "AWS::S3::Object"
      values = [
        "arn:aws:s3:::${var.origin_bucket_name}/",
        "arn:aws:s3:::${var.failover_bucket_name}/"
      ]
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logging" {
  bucket                  = aws_s3_bucket.logging.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
