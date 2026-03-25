resource "aws_s3_bucket" "artifacts" {
  bucket = var.artifact_bucket
  acl    = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = aws_kms_key.artifacts.arn
      }
    }
  }
  tags = {
    Name = "Image Builder artifacts"
  }
}

resource "aws_kms_key" "artifacts" {
  description             = "KMS key for pipeline artifacts"
  deletion_window_in_days = 30
  enable_key_rotation      = true
}

resource "aws_kms_alias" "artifacts" {
  name          = "alias/hardened-image-pipeline"
  target_key_id = aws_kms_key.artifacts.key_id
}

resource "aws_dynamodb_table" "pipeline" {
  name         = var.pipeline_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "run_id"
  attribute {
    name = "run_id"
    type = "S"
  }
  tags = {
    Name = "pipeline-metadata"
  }
}
