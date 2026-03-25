resource "aws_secretsmanager_secret" "lambda_token" {
  name        = "image-optimizer-token"
  description = "Credentials used by Lambda@Edge or monitoring hooks"
  rotation_rules {
    automatically_after_days = 90
  }
}

resource "aws_secretsmanager_secret_version" "lambda_token" {
  secret_id = aws_secretsmanager_secret.lambda_token.id
  secret_string = jsonencode({
    token = "REPLACE_WITH_SECURE_VALUE"
  })
}
