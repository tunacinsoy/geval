resource "aws_kms_key" "documents" {
  description             = "Encryption key for HR documents"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags = {
    Name = "hr-documents-key"
  }
}

resource "aws_kms_alias" "documents" {
  name          = "alias/hr-documents"
  target_key_id = aws_kms_key.documents.key_id
}

resource "aws_s3_bucket" "hr_documents" {
  bucket        = "secure-hr-documents-${var.environment}-${substr(var.region, 0, 3)}"
  acl           = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = aws_kms_key.documents.arn
      }
    }
  }
  versioning {
    enabled = true
  }
  object_lock_configuration {
    object_lock_enabled = "Enabled"
    rule {
      default_retention {
        mode  = "COMPLIANCE"
        days  = 365 * 7
      }
    }
  }
  lifecycle_rule {
    id      = "tier-cold"
    enabled = true
    prefix  = ""
    transition {
      days          = 365
      storage_class = "GLACIER_DEEP_ARCHIVE"
    }
    expiration {
      days = 365 * 7 + 30
    }
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.documents.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  ownership_controls {
    rule {
      object_ownership = "BucketOwnerEnforced"
    }
  }
  bucket_key_enabled = true
  depends_on = [aws_kms_alias.documents]
}

resource "aws_s3_bucket_public_access_block" "hr_documents" {
  bucket = aws_s3_bucket.hr_documents.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "hr_documents_replica" {
  provider = aws.replica
  bucket   = "secure-hr-documents-replica-${var.environment}"
  acl      = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
  ownership_controls {
    rule {
      object_ownership = "BucketOwnerPreferred"
    }
  }
}

resource "aws_iam_role" "replication" {
  name = "hr-s3-replication"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "replication" {
  name   = "hr-s3-replication"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.hr_documents.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionForReplication",
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Resource = "${aws_s3_bucket.hr_documents.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:PutObjectVersionAcl"
        ]
        Resource = "${aws_s3_bucket.hr_documents_replica.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

resource "aws_s3_bucket_replication_configuration" "hr_documents" {
  bucket = aws_s3_bucket.hr_documents.id
  role   = aws_iam_role.replication.arn
  rules {
    id     = "hr-docs-replication"
    status = "Enabled"
    destination {
      bucket        = aws_s3_bucket.hr_documents_replica.arn
      storage_class = "STANDARD"
    }
  }
}

resource "aws_s3_bucket" "audit_logs" {
  bucket        = "secure-hr-audit-logs-${var.environment}"
  acl           = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  lifecycle_rule {
    id      = "logs"
    enabled = true
    expiration {
      days = 365
    }
  }
}

resource "aws_s3_bucket_public_access_block" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
