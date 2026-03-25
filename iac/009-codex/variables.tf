variable "environment" {
  description = "Deployment environment identifier (dev|staging|prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region for the resolver bridge"
  type        = string
  default     = "us-east-1"
}

variable "aws_allowed_account_ids" {
  description = "List of AWS accounts that can manage this infrastructure"
  type        = list(string)
  default     = []
}

variable "vpc_cidr" {
  description = "CIDR block for the resolver VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs for resolver endpoints"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "availability_zones" {
  description = "Availability zones that host resolver subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "on_prem_cidr" {
  description = "CIDR range for on-premises DNS servers"
  type        = string
  default     = "192.168.10.0/24"
}

variable "transit_gateway_id" {
  description = "Existing Transit Gateway identifier"
  type        = string
}

variable "transit_gateway_route_table_id" {
  description = "Route table ID within the Transit Gateway"
  type        = string
}

variable "resolver_log_bucket" {
  description = "S3 bucket for exporting resolver logs"
  type        = string
}

variable "logging_retention_days" {
  description = "Retention window for CloudWatch resolver logs"
  type        = number
  default     = 30
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used for resolver logging"
  type        = string
}

locals {
  project_prefix = "resolver-bridge"
  common_tags = {
    Project     = "resolver-bridge"
    Environment = var.environment
    Owner       = "networking-team"
  }
}
