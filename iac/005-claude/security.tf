# Security Configuration for CloudFront CDN
# IAM roles, policies, and bucket security

# IAM Role for CloudFront service (minimal permissions)
resource "aws_iam_role" "cloudfront_service_role" {
  name = "cloudfront-service-role-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "cloudfront-service-role"
  }
}

# IAM Policy for cache invalidation
# Can be attached to CI/CD service accounts for automated cache purging
resource "aws_iam_policy" "cloudfront_cache_invalidation" {
  name        = "cloudfront-cache-invalidation-${var.environment}"
  description = "Policy for CloudFront cache invalidation operations"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudfront:CreateInvalidation",
          "cloudfront:GetInvalidation",
          "cloudfront:ListInvalidations",
          "cloudfront:GetDistribution",
          "cloudfront:ListDistributions"
        ]
        Resource = [
          aws_cloudfront_distribution.blog_cdn.arn,
          "${aws_cloudfront_distribution.blog_cdn.arn}/*"
        ]
      }
    ]
  })

  tags = {
    Name = "cloudfront-cache-invalidation"
  }
}

# IAM Policy for S3 logs bucket access
resource "aws_iam_policy" "s3_logs_access" {
  name        = "s3-logs-bucket-access-${var.environment}"
  description = "Policy for accessing CloudFront logs in S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.cloudfront_logs.arn,
          "${aws_s3_bucket.cloudfront_logs.arn}/*"
        ]
      }
    ]
  })

  tags = {
    Name = "s3-logs-access"
  }
}

# Outputs consolidated in outputs.tf
