# AWS Secrets Manager for Database Credential Management

# Secrets Manager Secret for Database Credentials
resource "aws_secretsmanager_secret" "db_password" {
  name_prefix             = "orders-db-password-${var.environment}-"
  description             = "Master password for Orders PostgreSQL database - ${var.environment}"
  recovery_window_in_days = 7 # Allow recovery for 7 days before permanent deletion

  tags = merge(
    var.tags,
    {
      Name = "orders-db-password-${var.environment}"
    }
  )
}

# Secret Version with actual credentials
resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    username            = var.db_username
    password            = random_password.db_password.result
    engine              = "postgres"
    host                = aws_db_instance.orders.address
    port                = aws_db_instance.orders.port
    dbname              = var.database_name
    dbClusterIdentifier = aws_db_instance.orders.db_name
  })

  depends_on = [aws_db_instance.orders]
}

# Automatic Password Rotation Configuration (production only)
# Note: This requires a Lambda function to implement the actual rotation
# The configuration here enables rotation tracking, but rotation logic must be external
resource "aws_secretsmanager_secret_rotation" "db_password" {
  count = var.environment == "prod" ? 1 : 0

  secret_id = aws_secretsmanager_secret.db_password.id
  rotation_rules {
    automatically_after_days = 90
  }

  depends_on = [aws_secretsmanager_secret_version.db_password]
}

# Lambda function for password rotation (placeholder - requires custom implementation)
# In production, implement a Lambda function that:
# 1. Connects to the database
# 2. Creates a new password
# 3. Updates the database user password
# 4. Rotates the secret version
#
# Example IAM policy needed for rotation Lambda:
# - RDS:ModifyDBUser
# - Secrets Manager: GetSecretValue, PutSecretValue
# - CloudWatch Logs: CreateLogGroup, CreateLogStream, PutLogEvents

# Database security policy to restrict access to the secret
resource "aws_secretsmanager_secret_policy" "db_password" {
  secret_arn = aws_secretsmanager_secret.db_password.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableApplicationAccess"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.application.arn
        }
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "*"
      },
      {
        Sid    = "EnableTerraformManagement"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.terraform_executor.arn
        }
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecret",
          "secretsmanager:RotateSecret"
        ]
        Resource = "*"
      }
    ]
  })
}

# CloudWatch Log Group for Secrets Manager (optional for rotation logging)
resource "aws_cloudwatch_log_group" "secrets_rotation" {
  count             = var.environment == "prod" ? 1 : 0
  name              = "/aws/secretsmanager/rotation/orders-${var.environment}"
  retention_in_days = 30

  tags = merge(
    var.tags,
    {
      Name = "secrets-rotation-logs-${var.environment}"
    }
  )
}
