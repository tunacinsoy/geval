resource "aws_cloudwatch_log_group" "resolver" {
  name              = "/resolver/${var.environment}/corp-internal"
  retention_in_days = var.logging_retention_days
  kms_key_id        = var.kms_key_arn
  tags              = var.common_tags
}

resource "aws_s3_bucket" "resolver_logs" {
  bucket = var.resolver_log_bucket

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = var.kms_key_arn
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "log-archive"
    enabled = true

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }
  }

  tags = merge(var.common_tags, {
    Name = "${local.project_prefix}-logs"
  })
}
