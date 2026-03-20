variable "primary_region" {
  description = "The primary AWS region."
  type        = string
}

variable "dr_region" {
  description = "The disaster recovery AWS region."
  type        = string
}

variable "app_instance_type" {
  description = "The instance type for the application."
  type        = string
}

variable "db_instance_type" {
  description = "The instance type for the database."
  type        = string
}

variable "min_app_instances" {
  description = "The minimum number of application instances."
  type        = number
}

variable "max_app_instances" {
  description = "The maximum number of application instances."
  type        = number
}
