# KMS Encryption Keys for S3 bucket and Terraform state

# Customer-managed KMS key for S3 document bucket encryption
resource "aws_kms_key" "s3_key" {
  description             = "KMS key for S3 HR documents bucket encryption (GDPR Article 32)"
  deletion_window_in_days = 30
  enable_key_rotation     = var.kms_key_rotation_enabled

  tags = merge(
    var.tags,
    {
      Name = "s3-documents-key-${var.environment}"
    }
  )
}

resource "aws_kms_alias" "s3_key" {
  name          = "alias/s3-documents-${var.environment}"
  target_key_id = aws_kms_key.s3_key.key_id
}

# KMS key policy for S3 encryption
resource "aws_kms_key_policy" "s3_key_policy" {
  key_id = aws_kms_key.s3_key.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM policies"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow S3 to use the key"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow CloudTrail to use the key"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow authorized IAM roles to decrypt"
        Effect = "Allow"
        Principal = {
          AWS = [
            aws_iam_role.hr_admin.arn,
            aws_iam_role.hr_manager.arn,
            aws_iam_role.hr_staff.arn
          ]
        }
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}

# Customer-managed KMS key for Terraform state encryption
resource "aws_kms_key" "terraform_state_key" {
  description             = "KMS key for Terraform state file encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = var.kms_key_rotation_enabled

  tags = merge(
    var.tags,
    {
      Name = "terraform-state-key-${var.environment}"
    }
  )
}

resource "aws_kms_alias" "terraform_state_key" {
  name          = "alias/terraform-state-${var.environment}"
  target_key_id = aws_kms_key.terraform_state_key.key_id
}

# CloudWatch logs for KMS key operations (audit trail)
resource "aws_cloudwatch_log_group" "kms_audit" {
  name              = "/aws/kms/audit/${var.environment}"
  retention_in_days = 365

  tags = merge(
    var.tags,
    {
      Name = "kms-audit-logs-${var.environment}"
    }
  )
}

# Data source for current AWS account ID
data "aws_caller_identity" "current" {}

# Data source for current AWS region
data "aws_region" "current" {}
