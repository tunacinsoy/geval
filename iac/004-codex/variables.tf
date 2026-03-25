variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "environment" {
  type        = string
  description = "Deployment environment name (dev/staging/prod)"
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnet_cidrs" {
  type = list(string)
  default = ["10.10.10.0/24", "10.10.11.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["us-east-2a", "us-east-2b"]
}

variable "website_vpc_id" {
  type        = string
  description = "Existing website VPC ID for PrivateLink or peering"
  default     = ""
}

variable "website_vpc_cidr" {
  type        = string
  description = "CIDR block for the website VPC peer"
  default     = ""
}

variable "db_instance_class" {
  type        = string
  description = "Instance class for the RDS primary"
}

variable "db_master_username" {
  type        = string
  description = "Master user name for the RDS PostgreSQL instance"
  default     = "dbadmin"
}

variable "db_allocated_storage" {
  type        = number
  default     = 500
  description = "Initial storage for the database (GB)"
}

variable "db_backup_retention_days" {
  type        = number
  default     = 35
}

variable "db_enable_read_replica" {
  type        = bool
  default     = false
}

variable "db_replica_count" {
  type        = number
  default     = 0
}

variable "route53_zone_name" {
  type    = string
  default = "orders.internal"
}

variable "import_bucket_suffix" {
  type    = string
  default = "customer-orders-import"
}

variable "export_bucket_suffix" {
  type    = string
  default = "customer-orders-export"
}

variable "audit_bucket_suffix" {
  type    = string
  default = "customer-orders-audit"
}

variable "fargate_cpu" {
  type    = number
  default = 512
}

variable "fargate_memory" {
  type    = number
  default = 1024
}

variable "fargate_desired_count" {
  type    = number
  default = 1
}

variable "lambda_timeout" {
  type    = number
  default = 60
}

variable "lambda_memory" {
  type    = number
  default = 512
}

variable "alert_email" {
  type        = string
  description = "Optional email for alert subscriptions"
  default     = ""
}
