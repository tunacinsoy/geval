variable "environment" {
  type        = string
  description = "Environment name (prod, staging, dev)"
  default     = "prod"

  validation {
    condition     = contains(["prod", "staging", "dev"], var.environment)
    error_message = "Environment must be prod, staging, or dev."
  }
}

variable "location" {
  type        = string
  description = "Azure region for resources"
  default     = "eastus"
}

variable "location_short" {
  type        = string
  description = "Short abbreviation for region (e.g., eus for eastus)"
  default     = "eus"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
  default     = "rg-001-private-aks-prod"
}

variable "naming_prefix" {
  type        = string
  description = "Naming prefix for all resources"
  default     = "001"
}

variable "project_name" {
  type        = string
  description = "Project name for resource naming"
  default     = "private-aks"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all resources"
  default = {
    Environment = "prod"
    Project     = "001-private-aks"
    ManagedBy   = "Terraform"
    CreatedDate = "2026-03-20"
  }
}

# Networking Variables
variable "vnet_cidr" {
  type        = string
  description = "Virtual Network CIDR block"
  default     = "10.0.0.0/16"
}

variable "control_plane_subnet_cidr" {
  type        = string
  description = "Control Plane subnet CIDR"
  default     = "10.0.1.0/25"
}

variable "node_subnet_cidr" {
  type        = string
  description = "Node subnet CIDR"
  default     = "10.0.10.0/22"
}

variable "firewall_subnet_cidr" {
  type        = string
  description = "Firewall subnet CIDR"
  default     = "10.0.20.0/26"
}

variable "private_endpoint_subnet_cidr" {
  type        = string
  description = "Private Endpoint subnet CIDR"
  default     = "10.0.30.0/27"
}

# Availability Zones
variable "availability_zones" {
  type        = list(string)
  description = "Availability zones for multi-AZ deployment"
  default     = ["1", "2", "3"]
}

# Firewall Variables
variable "firewall_sku_tier" {
  type        = string
  description = "Azure Firewall SKU tier (Standard or Premium)"
  default     = "Premium"

  validation {
    condition     = contains(["Standard", "Premium"], var.firewall_sku_tier)
    error_message = "Firewall SKU must be Standard or Premium."
  }
}

variable "firewall_enable_dns_proxy" {
  type        = bool
  description = "Enable DNS proxy on firewall for FQDN filtering"
  default     = true
}

# AKS Variables
variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version for AKS cluster"
  default     = "1.28"
}

variable "aks_node_count" {
  type        = number
  description = "Number of nodes in AKS node pool"
  default     = 3

  validation {
    condition     = var.aks_node_count >= 1 && var.aks_node_count <= 100
    error_message = "Node count must be between 1 and 100."
  }
}

variable "aks_vm_size" {
  type        = string
  description = "VM size for AKS nodes"
  default     = "Standard_D4s_v5"
}

variable "aks_os_disk_size_gb" {
  type        = number
  description = "OS disk size in GB for AKS nodes"
  default     = 128
}

variable "aks_enable_auto_scaling" {
  type        = bool
  description = "Enable cluster autoscaling (cost optimization: disabled)"
  default     = false
}

variable "aks_max_pods_per_node" {
  type        = number
  description = "Maximum pods per node"
  default     = 30
}

# Monitoring Variables
variable "log_analytics_retention_days" {
  type        = number
  description = "Log Analytics workspace retention in days (GDPR: 90 days minimum)"
  default     = 90

  validation {
    condition     = var.log_analytics_retention_days >= 90
    error_message = "Retention must be at least 90 days for GDPR compliance."
  }
}

variable "firewall_logs_retention_days" {
  type        = number
  description = "Firewall logs retention in days (GDPR: 90 days minimum)"
  default     = 90

  validation {
    condition     = var.firewall_logs_retention_days >= 90
    error_message = "Retention must be at least 90 days for GDPR compliance."
  }
}

# Alert Variables
variable "alert_action_group_name" {
  type        = string
  description = "Action group name for alerts"
  default     = "ag-aks-alerts"
}

variable "alert_email_receivers" {
  type        = list(string)
  description = "Email addresses for alert notifications"
  default     = []
}

variable "enable_alerts" {
  type        = bool
  description = "Enable monitoring alerts"
  default     = true
}
