# S3 Bucket for Test Artifacts
resource "aws_s3_bucket" "test_artifacts" {
  bucket = local.s3_bucket_name

  tags = merge(
    local.common_tags,
    {
      Name = local.s3_bucket_name
    }
  )
}

# Block Public Access (S3 bucket)
resource "aws_s3_bucket_public_access_block" "test_artifacts" {
  bucket = aws_s3_bucket.test_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "test_artifacts" {
  bucket = aws_s3_bucket.test_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"  # Default AWS encryption (no KMS cost)
    }
  }
}

# Versioning - Disabled (test data discarded, no rollback needed)
resource "aws_s3_bucket_versioning" "test_artifacts" {
  bucket = aws_s3_bucket.test_artifacts.id

  versioning_configuration {
    status = "Disabled"  # Cost optimization: test data not versioned
  }
}

# Bucket Policy - Allow EC2 instances to read/write
resource "aws_s3_bucket_policy" "test_artifacts" {
  bucket = aws_s3_bucket.test_artifacts.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEC2Access"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.ec2_role.arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.test_artifacts.arn,
          "${aws_s3_bucket.test_artifacts.arn}/*"
        ]
      }
    ]
  })
}

# Lifecycle Policy - NOT configured (data discarded on environment teardown)
# No archival or deletion rules; bucket deleted with infrastructure

# Outputs
output "s3_bucket_name" {
  description = "Name of the S3 bucket for test artifacts"
  value       = aws_s3_bucket.test_artifacts.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.test_artifacts.arn
}

output "s3_bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.test_artifacts.bucket_regional_domain_name
}
