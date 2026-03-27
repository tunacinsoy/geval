variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "db_instance_class" {
  description = "The instance class for the database."
  type        = string
}

variable "db_allocated_storage" {
  description = "The allocated storage for the database."
  type        = number
}

variable "db_name" {
  description = "The name of the database."
  type        = string
}

variable "db_username" {
  description = "The username for the database."
  type        = string
}

variable "db_password" {
  description = "The password for the database."
  type        = string
  sensitive   = true
}
