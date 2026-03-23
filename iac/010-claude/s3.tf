# S3 Buckets for Image Registry, Audit Logs, and Backups

# ============================================================================
# Image Registry Bucket
# ============================================================================

resource "aws_s3_bucket" "image_registry" {
  bucket = "${var.project_name}-ami-registry-${var.environment}"

  tags = {
    Name = "${var.project_name}-ami-registry-${var.environment}"
  }
}

resource "aws_s3_bucket_versioning" "image_registry" {
  bucket = aws_s3_bucket.image_registry.id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled" # Enable MFA delete for production
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "image_registry" {
  bucket = aws_s3_bucket.image_registry.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "image_registry" {
  bucket = aws_s3_bucket.image_registry.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "image_registry" {
  bucket = aws_s3_bucket.image_registry.id

  rule {
    id     = "archive-old-images"
    status = "Enabled"

    noncurrent_version_transition {
      noncurrent_days = var.image_retention_days
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 365 * 3 # 3 years retention
    }
  }
}

# ============================================================================
# Audit Logs Bucket
# ============================================================================

resource "aws_s3_bucket" "audit_logs" {
  bucket = "${var.project_name}-audit-logs-${var.environment}"

  tags = {
    Name = "${var.project_name}-audit-logs-${var.environment}"
  }
}

resource "aws_s3_bucket_versioning" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
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

resource "aws_s3_bucket_lifecycle_configuration" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id

  rule {
    id     = "archive-audit-logs"
    status = "Enabled"

    # Archive to Glacier after 90 days
    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    # Delete after 3 years (GDPR compliance)
    expiration {
      days = 365 * 3
    }
  }
}

# ============================================================================
# Terraform State Backup Bucket
# ============================================================================

resource "aws_s3_bucket" "terraform_state_backup" {
  bucket = "${var.project_name}-terraform-state-${var.environment}"

  tags = {
    Name = "${var.project_name}-terraform-state-backup-${var.environment}"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_backup" {
  bucket = aws_s3_bucket.terraform_state_backup.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_backup" {
  bucket = aws_s3_bucket.terraform_state_backup.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state_backup" {
  bucket = aws_s3_bucket.terraform_state_backup.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ============================================================================
# Outputs (referenced by other resources)
# ============================================================================

output "s3_image_registry_bucket" {
  value       = aws_s3_bucket.image_registry.bucket
  description = "S3 bucket for hardened AMI images"
}

output "s3_audit_logs_bucket" {
  value       = aws_s3_bucket.audit_logs.bucket
  description = "S3 bucket for audit logs (GDPR compliance)"
}

output "s3_terraform_backup_bucket" {
  value       = aws_s3_bucket.terraform_state_backup.bucket
  description = "S3 bucket for Terraform state backups"
}
