locals {
  bucket_base_name = format("%s-%s", var.environment, var.asset_bucket_suffix)
  sanitized_domain = replace(var.primary_domain, ".", "-")
  asset_bucket_name = lower(join("-", [local.bucket_base_name, local.sanitized_domain]))
  log_bucket_name = lower("${var.environment}-${var.log_bucket_suffix}")
}

resource "aws_s3_bucket" "assets" {
  bucket = local.asset_bucket_name
  acl    = "private"

  lifecycle {
    prevent_destroy = true
  }

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
    id      = "archive-old-objects"
    enabled = true

    transition {
      days          = 30
      storage_class = "INTELLIGENT_TIERING"
    }
  }

  tags = {
    Environment = var.environment
    Service     = "flower-shop-website"
  }
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "logs" {
  bucket = local.log_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "log-retention"
    enabled = true

    expiration {
      days = 90
    }
  }

  tags = {
    Environment = var.environment
    Service     = "flower-shop-logging"
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket policy allowing CloudFront OAC
resource "aws_s3_bucket_policy" "assets" {
  bucket = aws_s3_bucket.assets.id

  policy = data.aws_iam_policy_document.bucket_policy.json
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_control.assets.iam_arn]
    }

    resources = ["${aws_s3_bucket.assets.arn}/*"]
  }
}
