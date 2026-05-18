variable "region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type for the playground server"
  type        = string
  default     = "t3.small"
}

variable "volume_size" {
  description = "Root EBS volume size in GiB"
  type        = number
  default     = 20
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH into the instance"
  type        = list(string)
}

variable "ssh_public_key" {
  description = "SSH public key material for EC2 key pair"
  type        = string
}

variable "environment" {
  description = "Environment name for resource tagging"
  type        = string
  default     = "playground"
}

variable "expiry_date" {
  description = "Date when this environment should be destroyed (YYYY-MM-DD)"
  type        = string
  default     = "2026-06-01"
}

variable "owner" {
  description = "Team or individual owning this environment"
  type        = string
  default     = "team"
}

variable "project" {
  description = "Project identifier for resource naming and tagging"
  type        = string
  default     = "001-temp-playground"
}
