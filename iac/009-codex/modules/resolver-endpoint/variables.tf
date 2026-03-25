variable "name_prefix" {
  description = "Prefix for naming the resolver endpoint"
  type        = string
}

variable "direction" {
  description = "Resolver endpoint direction (INBOUND or OUTBOUND)"
  type        = string
}

variable "security_group_ids" {
  description = "Security groups attached to resolver endpoint"
  type        = list(string)
}

variable "subnet_ids" {
  description = "Subnets that host the resolver endpoint"
  type        = list(string)
}

variable "tags" {
  description = "Tags applied to resolver resources"
  type        = map(string)
  default     = {}
}
