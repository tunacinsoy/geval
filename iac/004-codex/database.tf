resource "aws_db_subnet_group" "default" {
  name       = "db-subnets-${var.environment}"
  subnet_ids = module.vpc.private_subnets
  description = "Subnet group for customer order database"
  tags = merge(var.common_tags, {
    Environment = var.environment
  })
}

resource "random_password" "db_master" {
  length           = 16
  override_characters = "!@#%&*"
  keepers = {
    environment = var.environment
  }
}

module "primary_db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 7.2"

  identifier = "customer-orders-${var.environment}"
  engine     = "postgresql"
  engine_version = "16.2"
  instance_class  = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_type      = "gp3"
  multi_az          = true
  username          = var.db_master_username
  password          = random_password.db_master.result
  db_subnet_group_name = aws_db_subnet_group.default.name
  create_db_subnet_group = false
  vpc_security_group_ids = [aws_security_group.database.id]
  backup_retention_period = var.db_backup_retention_days
  monitoring_interval = 60
  deletion_protection = true
  apply_immediately   = false
  skip_final_snapshot = false
  auto_minor_version_upgrade = true
  publicly_accessible = false
  storage_encrypted   = true
  replica_count       = var.db_enable_read_replica ? var.db_replica_count : 0
  performance_insights_enabled = false
}
