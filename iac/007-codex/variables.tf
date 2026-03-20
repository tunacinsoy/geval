variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Deployment environment identifier."
  type        = string
  default     = "prod"
}

variable "prefix" {
  description = "Name prefix applied to all resources."
  type        = string
  default     = "privaks"
}

variable "resource_group_name" {
  description = "Resource group that contains all platform resources."
  type        = string
  default     = "rg-privaks"
}

variable "backend_resource_group" {
  description = "Resource group that stores Terraform state."
  type        = string
  default     = "rg-privaks-state"
}

variable "backend_storage_account" {
  description = "Storage account used for the Terraform backend."
  type        = string
  default     = "tfstateprivaks"
}

variable "backend_container" {
  type    = string
  default = "tfstate"
}

variable "backend_key" {
  type    = string
  default = "priv-aks.tfstate"
}

variable "virtual_network_address_space" {
  description = "Address space for the main virtual network."
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "virtual_network_name" {
  type    = string
  default = "privaks-vnet"
}

variable "node_subnet_prefix" {
  type    = string
  default = "10.10.1.0/24"
}

variable "firewall_subnet_prefix" {
  type    = string
  default = "10.10.2.0/24"
}

variable "node_vm_size" {
  type    = string
  default = "Standard_D4s_v5"
}

variable "node_count" {
  type    = number
  default = 3
}

variable "node_pool_max" {
  type    = number
  default = 6
}

variable "node_zones" {
  type    = list(string)
  default = ["1", "2", "3"]
}

variable "aks_version" {
  type    = string
  default = "1.28.2"
}

variable "allowed_domains" {
  type    = list(string)
  default = ["*.docker.io", "*.ubuntu.com"]
}

variable "log_retention_days" {
  type    = number
  default = 90
}

variable "firewall_public_ip_sku" {
  type    = string
  default = "Standard"
}
