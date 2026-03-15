# Cross-Region Replication for Disaster Recovery

# Create KMS key for replica region (eu-central-1)
resource "aws_kms_key" "s3_key_replica" {
  provider            = aws.replica
  description         = "KMS key for replica S3 bucket encryption in secondary region"
  deletion_window_in_days = 30
  enable_key_rotation = var.kms_key_rotation_enabled

  tags = merge(
    var.tags,
    {
      Name = "s3-documents-replica-key-${var.environment}"
    }
  )
}

resource "aws_kms_alias" "s3_key_replica" {
  provider      = aws.replica
  name          = "alias/s3-documents-replica-${var.environment}"
  target_key_id = aws_kms_key.s3_key_replica.key_id
}

# Replica S3 bucket in secondary region
resource "aws_s3_bucket" "documents_replica" {
  provider = aws.replica
  bucket   = var.bucket_name_replica

  tags = merge(
    var.tags,
    {
      Name = "${var.bucket_name_replica}"
      Purpose = "Disaster recovery replica of HR documents bucket"
    }
  )
}

# Block public access to replica bucket
resource "aws_s3_bucket_public_access_block" "documents_replica" {
  provider = aws.replica
  bucket   = aws_s3_bucket.documents_replica.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning on replica bucket
resource "aws_s3_bucket_versioning" "documents_replica" {
  provider = aws.replica
  bucket   = aws_s3_bucket.documents_replica.id

  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [aws_s3_bucket_public_access_block.documents_replica]
}

# Server-side encryption for replica bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "documents_replica" {
  provider = aws.replica
  bucket   = aws_s3_bucket.documents_replica.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_key_replica.arn
    }
    bucket_key_enabled = true
  }

  depends_on = [aws_s3_bucket_public_access_block.documents_replica]
}

# Lifecycle policy for replica bucket
resource "aws_s3_bucket_lifecycle_configuration" "documents_replica" {
  provider = aws.replica
  bucket   = aws_s3_bucket.documents_replica.id

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

  depends_on = [aws_s3_bucket_versioning.documents_replica]
}

# Enable replication on primary bucket
resource "aws_s3_bucket_replication_configuration" "documents" {
  count      = var.cross_region_replication_enabled ? 1 : 0
  depends_on = [aws_s3_bucket_versioning.documents]
  bucket     = aws_s3_bucket.documents.id
  role       = aws_iam_role.s3_replication.arn

  rule {
    id     = "replicate-documents"
    status = "Enabled"

    filter {
      prefix = ""
    }

    destination {
      bucket       = aws_s3_bucket.documents_replica.arn
      storage_class = "STANDARD_IA"

      replication_time {
        status = "Enabled"
        time {
          minutes = 15
        }
      }

      metrics {
        status = "Enabled"
        event_threshold {
          minutes = 15
        }
      }

      encryption_configuration {
        replica_kms_key_id = aws_kms_key.s3_key_replica.arn
      }
    }

    delete_marker_replication {
      status = "Enabled"
    }
  }
}

# Provider configuration for replica region
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40, < 6.0"
    }
  }
}

provider "aws" {
  alias  = "replica"
  region = var.aws_region_replica

  default_tags {
    tags = {
      Environment         = var.environment
      ManagedBy          = "Terraform"
      DataClassification = "Confidential"
      Department         = "HR"
      Owner              = "Infrastructure"
      Project            = "HR-Document-Storage"
    }
  }
}
