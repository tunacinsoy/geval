# IAM Roles and Policies for Three-Tier HR Access Structure
# HR Admin: Full access (upload, download, delete, audit logs, manage permissions)
# HR Manager: Permissions for upload, download, view documents
# HR Staff: Read-only access to assigned documents

# ===== HR ADMIN ROLE =====
resource "aws_iam_role" "hr_admin" {
  name_prefix = "hr-admin-"
  description = "HR Admin role with full access to document storage and audit logs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:MultiFactorAuthPresent" = "true"
          }
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Role = "HR-Admin"
      MFA  = "Required"
    }
  )
}

resource "aws_iam_policy" "hr_admin_policy" {
  name_prefix = "hr-admin-policy-"
  description = "Policy for HR Admin with S3 object operations, version management, and audit log access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3ObjectManagement"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObjectVersion",
          "s3:DeleteObjectVersion",
          "s3:ListBucketVersions"
        ]
        Resource = [
          "${aws_s3_bucket.documents.arn}/*",
          "${aws_s3_bucket.documents_replica.arn}/*"
        ]
      },
      {
        Sid    = "S3BucketRead"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketVersioning",
          "s3:GetBucketPolicy",
          "s3:GetBucketLocation"
        ]
        Resource = [
          aws_s3_bucket.documents.arn,
          aws_s3_bucket.documents_replica.arn
        ]
      },
      {
        Sid    = "CloudTrailAuditAccess"
        Effect = "Allow"
        Action = [
          "cloudtrail:LookupEvents"
        ]
        Resource = "*"
      },
      {
        Sid    = "KMSKeyOperations"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = [
          aws_kms_key.s3_key.arn
        ]
      },
      {
        Sid    = "IAMUserManagement"
        Effect = "Allow"
        Action = [
          "iam:ListUsers",
          "iam:ListAttachedUserPolicies",
          "iam:ListAccessKeys"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(var.tags, { Role = "HR-Admin" })
}

resource "aws_iam_role_policy_attachment" "hr_admin" {
  role       = aws_iam_role.hr_admin.name
  policy_arn = aws_iam_policy.hr_admin_policy.arn
}

# ===== HR MANAGER ROLE =====
resource "aws_iam_role" "hr_manager" {
  name_prefix = "hr-manager-"
  description = "HR Manager role with permissions for upload, download, view documents"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Role = "HR-Manager"
      MFA  = "Not-Required"
    }
  )
}

resource "aws_iam_policy" "hr_manager_policy" {
  name_prefix = "hr-manager-policy-"
  description = "Policy for HR Manager with upload, download, and view permissions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3ObjectAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:GetObjectVersion"
        ]
        Resource = [
          aws_s3_bucket.documents.arn,
          "${aws_s3_bucket.documents.arn}/*"
        ]
      },
      {
        Sid    = "KMSKeyOperations"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = [
          aws_kms_key.s3_key.arn
        ]
      }
    ]
  })

  tags = merge(var.tags, { Role = "HR-Manager" })
}

resource "aws_iam_role_policy_attachment" "hr_manager" {
  role       = aws_iam_role.hr_manager.name
  policy_arn = aws_iam_policy.hr_manager_policy.arn
}

# ===== HR STAFF ROLE =====
resource "aws_iam_role" "hr_staff" {
  name_prefix = "hr-staff-"
  description = "HR Staff role with read-only access to assigned documents"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Role = "HR-Staff"
      MFA  = "Not-Required"
    }
  )
}

resource "aws_iam_policy" "hr_staff_policy" {
  name_prefix = "hr-staff-policy-"
  description = "Policy for HR Staff with read-only access to assigned documents"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3ReadOnlyAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.documents.arn,
          "${aws_s3_bucket.documents.arn}/*"
        ]
      },
      {
        Sid    = "KMSDecryptOnly"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = [
          aws_kms_key.s3_key.arn
        ]
      }
    ]
  })

  tags = merge(var.tags, { Role = "HR-Staff" })
}

resource "aws_iam_role_policy_attachment" "hr_staff" {
  role       = aws_iam_role.hr_staff.name
  policy_arn = aws_iam_policy.hr_staff_policy.arn
}

# ===== S3 REPLICATION ROLE =====
resource "aws_iam_role" "s3_replication" {
  name_prefix = "s3-replication-"
  description = "IAM role for S3 cross-region replication service"

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

  tags = merge(
    var.tags,
    {
      Name = "s3-replication-role-${var.environment}"
    }
  )
}

resource "aws_iam_policy" "s3_replication_policy" {
  name_prefix = "s3-replication-policy-"
  description = "Policy for S3 replication service to copy objects to replica bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadSourceBucket"
        Effect = "Allow"
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.documents.arn
      },
      {
        Sid    = "ReadObjectVersions"
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]
        Resource = "${aws_s3_bucket.documents.arn}/*"
      },
      {
        Sid    = "WriteReplicaBucket"
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Resource = "${aws_s3_bucket.documents_replica.arn}/*"
      },
      {
        Sid    = "KMSDecryptSource"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = aws_kms_key.s3_key.arn
      },
      {
        Sid    = "KMSEncryptReplica"
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = aws_kms_key.s3_key_replica.arn
      }
    ]
  })

  tags = merge(var.tags, { Name = "s3-replication-policy-${var.environment}" })
}

resource "aws_iam_role_policy_attachment" "s3_replication" {
  role       = aws_iam_role.s3_replication.name
  policy_arn = aws_iam_policy.s3_replication_policy.arn
}
