# CloudTrail Configuration for API Audit Logging and Compliance

# CloudTrail trail for API logging
resource "aws_cloudtrail" "documents" {
  count                          = var.enable_cloudtrail_logging ? 1 : 0
  name                           = "hr-documents-trail-${var.environment}"
  s3_bucket_name                 = aws_s3_bucket.cloudtrail_logs.id
  include_global_service_events  = true
  is_multi_region_trail          = true
  enable_log_file_validation     = true
  depends_on                     = [aws_s3_bucket_policy.cloudtrail_logs]

  tags = merge(
    var.tags,
    {
      Name = "hr-documents-cloudtrail-${var.environment}"
    }
  )
}

# CloudTrail S3 data events (log object-level API calls)
resource "aws_cloudtrail_data_event_selector" "s3_data_events" {
  count              = var.enable_cloudtrail_logging ? 1 : 0
  trail_name         = aws_cloudtrail.documents[0].name
  include_management_events = false

  data_resource {
    type   = "AWS::S3::Object"
    values = ["${aws_s3_bucket.documents.arn}/*"]
  }

  data_resource {
    type   = "AWS::S3::Bucket"
    values = [aws_s3_bucket.documents.arn]
  }
}

# CloudTrail management events (log API calls like PutObject, DeleteObject, etc.)
resource "aws_cloudtrail_event_selector" "management_events" {
  count                   = var.enable_cloudtrail_logging ? 1 : 0
  trail_name              = aws_cloudtrail.documents[0].name
  include_management_events = true

  read_write_type           = "All"
  include_global_service_events = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["${aws_s3_bucket.documents.arn}/*"]
    }
  }
}

# CloudWatch Log Group for CloudTrail events
resource "aws_cloudwatch_log_group" "cloudtrail" {
  count             = var.enable_cloudtrail_logging ? 1 : 0
  name              = "/aws/cloudtrail/hr-documents-${var.environment}"
  retention_in_days = 730

  tags = merge(
    var.tags,
    {
      Name = "cloudtrail-logs-${var.environment}"
    }
  )
}

# IAM role for CloudTrail to write to CloudWatch Logs
resource "aws_iam_role" "cloudtrail_cloudwatch" {
  count = var.enable_cloudtrail_logging ? 1 : 0
  name_prefix = "cloudtrail-cloudwatch-"
  description = "IAM role for CloudTrail to write logs to CloudWatch"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "cloudtrail-cloudwatch-role-${var.environment}"
    }
  )
}

# IAM policy for CloudTrail to write to CloudWatch Logs
resource "aws_iam_role_policy" "cloudtrail_cloudwatch" {
  count = var.enable_cloudtrail_logging ? 1 : 0
  name_prefix = "cloudtrail-cloudwatch-policy-"
  role        = aws_iam_role.cloudtrail_cloudwatch[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CreateLogStream"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream"
        ]
        Resource = "${aws_cloudwatch_log_group.cloudtrail[0].arn}:*"
      },
      {
        Sid    = "PutLogEvents"
        Effect = "Allow"
        Action = [
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.cloudtrail[0].arn}:*"
      }
    ]
  })
}

# CloudWatch Log Group resource policy to allow CloudTrail
resource "aws_cloudwatch_log_resource_policy" "cloudtrail" {
  count           = var.enable_cloudtrail_logging ? 1 : 0
  policy_name     = "cloudtrail-${var.environment}"

  policy_text = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudtrail"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "logs:PutLogEvents"
        Resource = "${aws_cloudwatch_log_group.cloudtrail[0].arn}:*"
      }
    ]
  })
}

# Metric filter for unauthorized access attempts (403 errors)
resource "aws_cloudwatch_log_group_metric_filter" "unauthorized_access" {
  count          = var.enable_cloudtrail_logging ? 1 : 0
  name           = "UnauthorizedAccessAttempts"
  log_group_name = aws_cloudwatch_log_group.cloudtrail[0].name
  filter_pattern = "{ ($.errorCode = \"AccessDenied*\") || ($.errorCode = \"UnauthorizedOperation\") }"

  metric_transformation {
    name      = "UnauthorizedAccessCount"
    namespace = "HR-Documents-Security"
    value     = "1"
  }
}

# Metric filter for S3 object deletions
resource "aws_cloudwatch_log_group_metric_filter" "object_deletions" {
  count          = var.enable_cloudtrail_logging ? 1 : 0
  name           = "S3ObjectDeletions"
  log_group_name = aws_cloudwatch_log_group.cloudtrail[0].name
  filter_pattern = "{ ($.eventName = \"DeleteObject*\") }"

  metric_transformation {
    name      = "DeletionCount"
    namespace = "HR-Documents-Audit"
    value     = "1"
  }
}
