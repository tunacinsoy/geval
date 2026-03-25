variable "vpc_id" {
  description = "The ID of the VPC where the resolver endpoints will be created."
  type        = string
}

variable "subnet_ids" {
  description = "A list of two subnet IDs from different AZs for the resolver endpoints."
  type        = list(string)
  validation {
    condition     = length(var.subnet_ids) == 2
    error_message = "Exactly two subnet IDs must be provided."
  }
}

variable "on_prem_dns_ips" {
  description = "A list of IP addresses for the on-premise DNS servers."
  type        = list(string)
  default     = ["192.168.10.5", "192.168.10.6"]
}

variable "on_prem_cidr" {
  description = "The CIDR block for the on-premise network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "domain_name" {
  description = "The domain name for which to forward DNS queries."
  type        = string
  default     = "corp.internal"
}

variable "tags" {
  description = "A map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}
