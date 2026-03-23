variable "aws_region" {
  description = "AWS region for infrastructure deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod"
  }
}

variable "cost_center" {
  description = "Cost center code for resource tagging and billing"
  type        = string
  default     = "engineering"
}

variable "vpc_cidr" {
  description = "VPC CIDR block for resolver endpoints"
  type        = string
  default     = "10.0.0.0/16"
}

variable "inbound_endpoint_subnet_cidr" {
  description = "CIDR block for inbound resolver endpoint subnet"
  type        = string
  default     = "10.0.10.0/24"
}

variable "outbound_endpoint_subnet_cidr" {
  description = "CIDR block for outbound resolver endpoint subnet"
  type        = string
  default     = "10.0.11.0/24"
}

variable "on_premises_cidr" {
  description = "On-premises network CIDR block for security group rules"
  type        = string
  default     = "192.168.0.0/16"
}

variable "on_premises_dns_servers" {
  description = "List of on-premises DNS server IP addresses"
  type        = list(string)
  default     = ["192.168.10.5", "192.168.10.6"]
}

variable "transit_gateway_attachment_id" {
  description = "Transit Gateway attachment ID for hybrid network connectivity"
  type        = string
}

variable "dns_query_log_retention" {
  description = "CloudWatch log group retention in days (30=dev, 60=staging, 90=prod)"
  type        = number
  default     = 30
}

variable "create_cloudwatch_alarms" {
  description = "Whether to create CloudWatch alarms for monitoring"
  type        = bool
  default     = true
}
