resource "aws_s3_bucket" "artifacts" {
  bucket = "playground-share-logs"

  lifecycle_rule {
    enabled = true
    id      = "short-lived-objects"

    transition {
      days          = 1
      storage_class = "INTELLIGENT_TIERING"
    }

    expiration {
      days = 7
    }
  }

  tags = {
    Environment = var.environment
    Purpose     = "playground-logs"
  }
}
