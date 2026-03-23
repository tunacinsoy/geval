variable "location" {
  description = "The Azure region to deploy the resources."
  type        = string
  default     = "eastus"
}

variable "prefix" {
  description = "A prefix to be added to all resource names."
  type        = string
  default     = "gemini"
}
