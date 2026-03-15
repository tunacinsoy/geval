# Primary S3 Bucket for HR Documents

# S3 bucket for HR documents with encryption and versioning
resource "aws_s3_bucket" "documents" {
  bucket = var.bucket_name

  tags = merge(
    var.tags,
    {
      Name = "${var.bucket_name}"
    }
  )
}

# Block public access to bucket
resource "aws_s3_bucket_public_access_block" "documents" {
  bucket = aws_s3_bucket.documents.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning for accidental deletion recovery
resource "aws_s3_bucket_versioning" "documents" {
  bucket = aws_s3_bucket.documents.id

  versioning_configuration {
    status     = var.versioning_enabled ? "Enabled" : "Suspended"
    mfa_delete = var.mfa_delete_enabled ? "Enabled" : "Disabled"
  }

  depends_on = [aws_s3_bucket_public_access_block.documents]
}

# Server-side encryption with KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "documents" {
  bucket = aws_s3_bucket.documents.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_key.arn
    }
    bucket_key_enabled = true
  }

  depends_on = [aws_s3_bucket_public_access_block.documents]
}

# Enforce TLS 1.2+ and deny unencrypted uploads via bucket policy
resource "aws_s3_bucket_policy" "documents" {
  bucket = aws_s3_bucket.documents.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyUnencryptedObjectUploads"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.documents.arn}/*"
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption" = "aws:kms"
          }
        }
      },
      {
        Sid    = "DenyIncorrectKMSKey"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.documents.arn}/*"
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption-aws-kms-key-id" = aws_kms_key.s3_key.arn
          }
        }
      },
      {
        Sid    = "DenyNonSecureTransport"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:*"
        Resource = [
          aws_s3_bucket.documents.arn,
          "${aws_s3_bucket.documents.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      {
        Sid    = "AllowAuthorizedRoles"
        Effect = "Allow"
        Principal = {
          AWS = [
            aws_iam_role.hr_admin.arn,
            aws_iam_role.hr_manager.arn,
            aws_iam_role.hr_staff.arn
          ]
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.documents.arn,
          "${aws_s3_bucket.documents.arn}/*"
        ]
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.documents]
}

# Lifecycle policy: transition to cheaper tiers, expire after 7 years
resource "aws_s3_bucket_lifecycle_configuration" "documents" {
  bucket = aws_s3_bucket.documents.id

  rule {
    id     = "transition-to-tiering"
    status = "Enabled"

    transition {
      days          = var.lifecycle_transition_days
      storage_class = "INTELLIGENT_TIERING"
    }

    transition {
      days          = var.lifecycle_expiration_years * 365
      storage_class = "GLACIER"
    }

    expiration {
      days = var.lifecycle_expiration_years * 365
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }

  depends_on = [aws_s3_bucket_versioning.documents]
}

# Enable logging to separate bucket
resource "aws_s3_bucket_logging" "documents" {
  bucket = aws_s3_bucket.documents.id

  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "s3-access-logs/"

  depends_on = [aws_s3_bucket_policy.logs]
}

# Tags for compliance and cost tracking
resource "aws_s3_bucket_tagging" "documents" {
  bucket = aws_s3_bucket.documents.id

  tags = merge(
    var.tags,
    {
      DataClassification = "Confidential"
      Department         = "HR"
    }
  )
}
