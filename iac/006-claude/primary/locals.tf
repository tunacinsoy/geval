locals {
  # Common naming convention
  name_prefix = "${var.project_name}-${var.environment}"

  # Region-specific naming
  region_short = substr(var.aws_region, 0, 2) # eu for eu-central-1

  # Common tags applied to all resources
  common_tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Region      = var.aws_region
      RegionShort = local.region_short
      Terraform   = "true"
    }
  )

  # Network-related locals
  vpc_name = "${local.name_prefix}-vpc"

  public_subnet_names = [
    "${local.name_prefix}-public-subnet-${var.availability_zones[0]}",
    "${local.name_prefix}-public-subnet-${var.availability_zones[1]}"
  ]

  private_app_subnet_names = [
    "${local.name_prefix}-private-app-subnet-${var.availability_zones[0]}",
    "${local.name_prefix}-private-app-subnet-${var.availability_zones[1]}"
  ]

  private_db_subnet_names = [
    "${local.name_prefix}-private-db-subnet-${var.availability_zones[0]}",
    "${local.name_prefix}-private-db-subnet-${var.availability_zones[1]}"
  ]

  # Security group naming
  alb_sg_name         = "${local.name_prefix}-alb-sg"
  app_instance_sg_name = "${local.name_prefix}-app-instance-sg"
  rds_sg_name         = "${local.name_prefix}-rds-sg"

  # RDS naming
  db_cluster_identifier = "${local.name_prefix}-aurora-cluster"
  db_cluster_name       = "${local.name_prefix}-db"

  # ALB naming
  alb_name           = "${local.name_prefix}-alb"
  target_group_name  = "${local.name_prefix}-tg"

  # ASG naming
  launch_template_name = "${local.name_prefix}-launch-template"
  asg_name             = "${local.name_prefix}-asg"

  # IAM naming
  terraform_role_name        = "${local.name_prefix}-terraform-role"
  instance_role_name         = "${local.name_prefix}-instance-role"
  instance_profile_name      = "${local.name_prefix}-instance-profile"
  rds_monitoring_role_name   = "${local.name_prefix}-rds-monitoring-role"

  # S3 naming for state buckets
  state_bucket_primary   = "terraform-state-primary-${data.aws_caller_identity.current.account_id}"
  state_bucket_secondary = "terraform-state-secondary-${data.aws_caller_identity.current.account_id}"

  # DynamoDB naming for state locking
  state_lock_table_primary   = "terraform-locks-primary"
  state_lock_table_secondary = "terraform-locks-secondary"

  # CloudWatch naming
  cloudwatch_log_group = "/aws/ec2/${local.name_prefix}/application-instances"

  # Route 53 naming
  route53_health_check_primary_name   = "${local.name_prefix}-primary-health-check"
  route53_health_check_secondary_name = "${local.name_prefix}-secondary-health-check"

  # SNS naming for failover alerts
  failover_alarm_topic_name = "${local.name_prefix}-failover-alerts"
}

# Data source for current AWS account ID
data "aws_caller_identity" "current" {}

# Data source for current region
data "aws_region" "current" {
  provider = aws
}
