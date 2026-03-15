# This is the main configuration file for the secure HR document storage.

provider "aws" {
  region = var.aws_region
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1" # Pinning to a specific version of the module

  bucket = var.bucket_name
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule = [
    {
      id      = "expire-noncurrent-versions"
      enabled = true
      noncurrent_version_expiration = {
        noncurrent_days = 30
      }
    }
  ]
}

resource "aws_iam_group" "hr_group" {
  name = var.iam_group_name
}

resource "aws_iam_policy" "hr_policy" {
  name        = "${var.iam_group_name}-policy"
  description = "Policy for accessing the secure HR documents S3 bucket."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          module.s3_bucket.s3_bucket_arn,
          "${module.s3_bucket.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "hr_policy_attachment" {
  group      = aws_iam_group.hr_group.name
  policy_arn = aws_iam_policy.hr_policy.arn
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3_bucket.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EnforceSecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          module.s3_bucket.s3_bucket_arn,
          "${module.s3_bucket.s3_bucket_arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}
