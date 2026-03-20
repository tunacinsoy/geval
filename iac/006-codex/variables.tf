variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prod"
}

variable "primary_region" {
  description = "Primary region for workloads"
  type        = string
  default     = "eu-central-1"
}

variable "dr_region" {
  description = "Disaster recovery region"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR block shared between the primary and DR VPCs"
  type        = string
  default     = "10.10.0.0/16"
}

variable "application_instance_type" {
  description = "Compute instance type for application tier"
  type        = string
  default     = "c6i.large"
}

variable "application_desired_capacity" {
  description = "Baseline number of application instances"
  type        = number
  default     = 2
}

variable "database_master_username" {
  description = "Database master user"
  type        = string
  default     = "aurora_admin"
}

variable "database_name" {
  description = "Primary database name"
  type        = string
  default     = "appdb"
}

variable "key_pair_name" {
  description = "Optional EC2 key pair for SSH"
  type        = string
  default     = ""
}

variable "db_backup_retention" {
  description = "Days to retain automated database backups"
  type        = number
  default     = 7
}

variable "dns_zone_id" {
  description = "Route53 hosted zone identifier for application DNS"
  type        = string
}

variable "dns_domain" {
  description = "DNS name used for the load balancer"
  type        = string
  default     = "app.example.com"
}

variable "enable_nat_instances" {
  description = "Use NAT instances in dev for cost control"
  type        = bool
  default     = false
}
