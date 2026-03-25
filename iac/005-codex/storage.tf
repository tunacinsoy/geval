resource "aws_kms_key" "image_delivery" {
  description             = "Encryption key for global image storage and logging"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

resource "aws_kms_alias" "image_delivery_alias" {
  name          = "alias/global-image-delivery"
  target_key_id = aws_kms_key.image_delivery.key_id
}

resource "aws_s3_bucket" "primary" {
  bucket = var.origin_bucket_name
  acl    = "private"
  region = var.aws_region

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.image_delivery.arn
      }
    }
  }

  lifecycle_rule {
    enabled = true
    id      = "retain-recent"
    expiration {
      days = 365
    }
  }

  tags = {
    Environment = "global"
    Purpose     = "Primary image origin"
  }
}

resource "aws_s3_bucket" "failover" {
  bucket = var.failover_bucket_name
  acl    = "private"
  region = var.aws_region

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.image_delivery.arn
      }
    }
  }

  lifecycle_rule {
    enabled = true
    id      = "glacier-transition"
    transition {
      days          = 90
      storage_class = "GLACIER_IR"
    }
  }

  tags = {
    Environment = "global"
    Purpose     = "Failover origin"
  }
}

resource "aws_s3_bucket" "logging" {
  bucket = var.logging_bucket_name
  acl    = "log-delivery-write"
  region = var.aws_region

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.image_delivery.arn
      }
    }
  }

  tags = {
    Environment = "global"
    Purpose     = "CloudFront log sink"
  }
}

resource "aws_iam_role" "replication" {
  name = "image-delivery-replication"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "replication" {
  name = "image-delivery-replication-policy"
  role = aws_iam_role.replication.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionForReplication"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.primary.arn}/*"
      },
      {
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:PutObjectAcl"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.failover.arn}/*"
      },
      {
        Action   = "kms:Decrypt"
        Effect   = "Allow"
        Resource = aws_kms_key.image_delivery.arn
      }
    ]
  })
}

resource "aws_s3_bucket_replication_configuration" "image" {
  bucket = aws_s3_bucket.primary.id
  role   = aws_iam_role.replication.arn

  rules {
    id     = "primary-to-failover"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.failover.arn
      storage_class = "STANDARD"
    }

    filter {
      prefix = ""
    }
  }
}

resource "aws_s3_bucket_metric" "cache_behaviors" {
  bucket = aws_s3_bucket.primary.id
  name   = "cache_behaviors"

  filter {
    prefix = "images/"
  }
}

resource "aws_s3_bucket_analytics_configuration" "cache_analysis" {
  bucket = aws_s3_bucket.primary.id
  name   = "cache-hit-analysis"

  storage_class_analysis {
    data_export {
      output_schema_version = "V_1"
      destination {
        s3_bucket_destination {
          bucket_arn = aws_s3_bucket.logging.arn
          format     = "CSV"
        }
      }
    }
  }
}
