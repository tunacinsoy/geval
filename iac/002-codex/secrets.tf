resource "aws_secretsmanager_secret" "tls" {
  name = "hr-portal-tls"
  description = "Placeholder secret storing TLS metadata"
  recovery_window_in_days = 7
  tags = {
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "tls" {
  secret_id     = aws_secretsmanager_secret.tls.id
  secret_string = jsonencode({
    certificate = var.acm_certificate_arn
  })
}

resource "aws_secretsmanager_secret" "audit" {
  name = "hr-portal-audit"
  description = "Keys for third-party audit sharing"
  recovery_window_in_days = 30
}

resource "aws_secretsmanager_secret_version" "audit" {
  secret_id     = aws_secretsmanager_secret.audit.id
  secret_string = jsonencode({
    token = "audit-token-placeholder"
  })
}
