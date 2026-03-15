locals {
  # Environment configuration
  environment    = var.environment
  project_name   = var.project_name
  aws_region     = var.aws_region
  creation_date  = "2026-03-15"
  expiration_date = "2026-04-15"

  # Resource naming conventions
  resource_prefix = "${local.environment}-${local.project_name}"

  # Networking
  vpc_cidr_block      = var.vpc_cidr_block
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.10.0/24"
  availability_zone   = "${local.aws_region}a"

  # Compute
  instance_count   = var.instance_count
  instance_type    = var.instance_type
  db_instance_type = var.rds_instance_class

  # Database
  db_name                = "testdb"
  db_allocated_storage   = var.db_allocated_storage
  db_backup_retention    = 7
  db_engine              = "postgres"
  db_engine_version      = "15.5"

  # Storage
  s3_bucket_name = "${local.environment}-${local.project_name}-test-artifacts-${data.aws_caller_identity.current.account_id}"

  # Tags applied to all resources
  common_tags = {
    Environment    = local.environment
    Project        = local.project_name
    CreatedDate    = local.creation_date
    ExpirationDate = local.expiration_date
    CostCenter     = "engineering"
    AutoShutdown   = false
  }
}

# Data source for current AWS account ID
data "aws_caller_identity" "current" {}
