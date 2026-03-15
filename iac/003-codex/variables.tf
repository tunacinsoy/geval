variable "region" {
  description = "Primary AWS region for the playground"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Logical environment name"
  type        = string
  default     = "playground"
}

variable "vpc_cidr" {
  description = "CIDR range for the playground VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.20.10.0/24"]
}

variable "allowed_cidrs" {
  description = "CIDRs allowed to reach the playground ALB"
  type        = list(string)
  default     = ["203.0.113.0/24"]
}

variable "certificate_arn" {
  description = "Certificate ARN for HTTPS listener"
  type        = string
  default     = "arn:aws:acm:us-east-1:000000000000:certificate/example"
}

variable "instance_type" {
  description = "Base compute instance type"
  type        = string
  default     = "t3.micro"
}

variable "burst_instance_type" {
  description = "Instance type when the team requests a capacity boost"
  type        = string
  default     = "t3.small"
}

variable "max_size" {
  description = "Maximum compute resource count"
  type        = number
  default     = 2
}

variable "expiration_days" {
  description = "Number of days before the playground is scheduled for teardown"
  type        = number
  default     = 14
}

variable "team_dns_prefix" {
  description = "Prefix for private DNS entries"
  type        = string
  default     = "playground.internal.feature-team"
}

variable "allowed_private_zone" {
  description = "Route53 private hosted zone name"
  type        = string
  default     = "playground.internal.feature-team.example.com"
}
