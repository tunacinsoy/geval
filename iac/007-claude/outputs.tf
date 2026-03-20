output "resource_group_name" {
  description = "Name of the resource group"
  value       = data.azurerm_resource_group.rg.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = data.azurerm_resource_group.rg.id
}

# VNet Outputs
output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

# Subnet Outputs
output "control_plane_subnet_id" {
  description = "ID of control plane subnet"
  value       = azurerm_subnet.control_plane.id
}

output "node_subnet_id" {
  description = "ID of node subnet"
  value       = azurerm_subnet.node.id
}

output "firewall_subnet_id" {
  description = "ID of firewall subnet"
  value       = azurerm_subnet.firewall.id
}

# Firewall Outputs
output "firewall_primary_id" {
  description = "ID of primary firewall"
  value       = azurerm_firewall.primary.id
}

output "firewall_primary_private_ip" {
  description = "Private IP address of primary firewall"
  value       = azurerm_firewall.primary.ip_configuration[0].private_ip_address
}

output "firewall_secondary_id" {
  description = "ID of secondary firewall (failover)"
  value       = azurerm_firewall.secondary.id
}

output "firewall_secondary_private_ip" {
  description = "Private IP address of secondary firewall"
  value       = azurerm_firewall.secondary.ip_configuration[0].private_ip_address
}

# AKS Outputs
output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_kubernetes_version" {
  description = "Kubernetes version of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.kubernetes_version
}

output "aks_private_fqdn" {
  description = "Private FQDN of AKS control plane API server"
  value       = azurerm_kubernetes_cluster.aks.private_fqdn
}

output "aks_managed_identity" {
  description = "Managed identity for AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  sensitive   = true
}

output "aks_node_resource_group" {
  description = "Resource group for AKS nodes"
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

# Key Vault Outputs
output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.kv.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.kv.name
}

# Monitoring Outputs
output "log_analytics_workspace_id" {
  description = "ID of Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.oms.id
}

output "log_analytics_workspace_name" {
  description = "Name of Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.oms.name
}

output "firewall_logs_storage_account_id" {
  description = "ID of storage account for firewall logs"
  value       = azurerm_storage_account.firewall_logs.id
}

output "firewall_logs_storage_account_name" {
  description = "Name of storage account for firewall logs"
  value       = azurerm_storage_account.firewall_logs.name
}

# Private Endpoint Outputs
output "aks_private_endpoint_id" {
  description = "ID of private endpoint for AKS control plane"
  value       = azurerm_private_endpoint.aks_control_plane.id
}

output "aks_private_endpoint_name" {
  description = "Name of private endpoint for AKS control plane"
  value       = azurerm_private_endpoint.aks_control_plane.name
}

# Cluster Access Information
output "kubectl_config_command" {
  description = "Command to retrieve kubeconfig"
  value       = "az aks get-credentials --name ${azurerm_kubernetes_cluster.aks.name} --resource-group ${data.azurerm_resource_group.rg.name} --overwrite-existing"
}

output "cluster_access_note" {
  description = "Note about cluster access"
  value       = "This is a private cluster. Access via private endpoint requires network connectivity to the VNet or VPN connection."
}
