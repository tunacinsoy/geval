resource "aws_secretsmanager_secret" "playground" {
  name = "playground-credentials"
  description = "API keys and tokens used only in the temporary playground"
  tags = {
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "playground" {
  secret_id     = aws_secretsmanager_secret.playground.id
  secret_string = jsonencode({
    api_key    = "placeholder"
    created_at = timestamp()
  })
}
