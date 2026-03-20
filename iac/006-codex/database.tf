resource "aws_rds_cluster" "aurora_primary" {
  engine          = "aurora-postgresql"
  engine_version  = "15.2"
  database_name   = var.database_name
  master_username = var.database_master_username
  master_password = data.aws_secretsmanager_secret_version.db_credentials.secret_string
  skip_final_snapshot = true
  preferred_backup_window = "03:00-04:00"
  backup_retention_period = var.db_backup_retention
  storage_encrypted = true
  kms_key_id        = "alias/aurora-key"
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.app.name
}

resource "aws_rds_global_cluster" "aurora_global" {
  global_cluster_identifier = "aurora-global-${var.environment}"
  engine                    = "aurora-postgresql"
  storage_encrypted         = true
  deletion_protection       = true
}

resource "aws_rds_cluster" "aurora_dr" {
  provider         = aws.dr
  engine           = "aurora-postgresql"
  engine_version   = "15.2"
  database_name    = var.database_name
  master_username  = var.database_master_username
  master_password  = data.aws_secretsmanager_secret_version.db_credentials.secret_string
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.app.name
  global_cluster_identifier = aws_rds_global_cluster.aurora_global.id
}

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "db-credentials-${var.environment}"
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.database_master_username
    password = random_password.db_password.result
  })
}

resource "random_password" "db_password" {
  length           = 20
  special          = true
  override_characters = "@#"
}

resource "aws_db_subnet_group" "app" {
  name       = "db-subnet-${var.environment}"
  subnet_ids = values(aws_subnet.primary_private)[*].id
  tags = {
    Environment = var.environment
  }
}
