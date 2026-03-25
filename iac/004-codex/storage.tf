resource "aws_s3_bucket" "import_bucket" {
  bucket = "${var.import_bucket_suffix}-${var.environment}"
  acl    = "private"

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

  tags = merge(var.common_tags, {
    Environment = var.environment
  })
}

resource "aws_s3_bucket" "export_bucket" {
  bucket = "${var.export_bucket_suffix}-${var.environment}"
  acl    = "private"

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

  tags = merge(var.common_tags, {
    Environment = var.environment
  })
}

resource "aws_s3_bucket" "audit_bucket" {
  bucket = "${var.audit_bucket_suffix}-${var.environment}"
  acl    = "private"

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

  tags = merge(var.common_tags, {
    Environment = var.environment
  })
}

resource "aws_s3_bucket_lifecycle_configuration" "import_lifecycle" {
  bucket = aws_s3_bucket.import_bucket.id

  rule {
    id     = "import-cleanup"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 1095
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "export_lifecycle" {
  bucket = aws_s3_bucket.export_bucket.id

  rule {
    id     = "export-retain"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 1095
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "audit_lifecycle" {
  bucket = aws_s3_bucket.audit_bucket.id

  rule {
    id     = "audit-retention"
    status = "Enabled"

    transition {
      days          = 180
      storage_class = "GLACIER"
    }

    expiration {
      days = 3650
    }
  }
}
