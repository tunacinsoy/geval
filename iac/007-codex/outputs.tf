output "aks_private_fqdn" {
  description = "Private endpoint FQDN for the AKS control plane."
  value       = azurerm_kubernetes_cluster.main.private_fqdn
}

output "firewall_private_ip" {
  description = "Azure Firewall private IP for egress routing."
  value       = azurerm_firewall.main.private_ip_address
}

output "log_workspace_id" {
  description = "Log Analytics workspace id used for diagnostics."
  value       = azurerm_log_analytics_workspace.main.id
}
