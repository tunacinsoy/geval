# Log Analytics Workspace for Monitoring
resource "azurerm_log_analytics_workspace" "oms" {
  name                = local.log_analytics_workspace_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_analytics_retention_days

  tags = local.tags
}

# Storage Account for Firewall Logs (GDPR: 90+ day retention)
resource "azurerm_storage_account" "firewall_logs" {
  name                       = local.storage_account_firewall_logs
  location                   = data.azurerm_resource_group.rg.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  access_tier                = "Hot"
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"

  tags = local.tags
}

# Blob Container for Firewall Logs
resource "azurerm_storage_container" "firewall_logs" {
  name                  = "firewall-logs"
  storage_account_name  = azurerm_storage_account.firewall_logs.name
  container_access_type = "private"

  depends_on = [azurerm_storage_account.firewall_logs]
}

# Storage Account Lifecycle Policy (Archive after 90 days)
resource "azurerm_storage_management_policy" "firewall_logs_lifecycle" {
  storage_account_id = azurerm_storage_account.firewall_logs.id

  rule {
    name    = "firewall-logs-retention"
    enabled = true
    filters {
      blob_types   = ["blockBlob"]
      prefix_match = ["firewall-logs"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = var.firewall_logs_retention_days
      }
    }
  }
}

# Action Group for Alerts
resource "azurerm_monitor_action_group" "aks_alerts" {
  name                = local.action_group_name
  resource_group_name = data.azurerm_resource_group.rg.name
  short_name          = "AKS-Alerts"

  tags = local.tags
}

# Alert: Node CPU Utilization > 85%
resource "azurerm_monitor_metric_alert" "node_cpu_utilization" {
  count               = var.enable_alerts ? 1 : 0
  name                = "${local.aks_cluster_name}-alert-cpu-high"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [azurerm_kubernetes_cluster.aks.id]
  description         = "Alert when node CPU utilization exceeds 85%"
  severity            = 3
  frequency           = "PT5M"
  window_duration     = "PT15M"
  enabled             = true

  criteria {
    metric_name      = "node_cpu_usage_percentage"
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 85
  }

  action {
    action_group_id = azurerm_monitor_action_group.aks_alerts.id
  }

  tags = local.tags
}

# Alert: Node Memory Utilization > 90%
resource "azurerm_monitor_metric_alert" "node_memory_utilization" {
  count               = var.enable_alerts ? 1 : 0
  name                = "${local.aks_cluster_name}-alert-memory-high"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [azurerm_kubernetes_cluster.aks.id]
  description         = "Alert when node memory utilization exceeds 90%"
  severity            = 3
  frequency           = "PT5M"
  window_duration     = "PT15M"
  enabled             = true

  criteria {
    metric_name      = "node_memory_usage_percentage"
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }

  action {
    action_group_id = azurerm_monitor_action_group.aks_alerts.id
  }

  tags = local.tags
}

# Alert: Firewall Health Status
resource "azurerm_monitor_metric_alert" "firewall_health" {
  count               = var.enable_alerts ? 1 : 0
  name                = "${local.firewall_primary_name}-alert-health"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [azurerm_firewall.primary.id]
  description         = "Alert when firewall health is degraded"
  severity            = 2
  frequency           = "PT5M"
  window_duration     = "PT5M"
  enabled             = true

  criteria {
    metric_name      = "FirewallHealth"
    metric_namespace = "Microsoft.Network/azureFirewalls"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 90
  }

  action {
    action_group_id = azurerm_monitor_action_group.aks_alerts.id
  }

  tags = local.tags
}

# Kubernetes Dashboard (Container Insights)
resource "azurerm_monitor_diagnostic_setting" "kube_metrics" {
  name                       = "${local.aks_cluster_name}-kube-metrics"
  target_resource_id         = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.oms.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }

  depends_on = [azurerm_log_analytics_workspace.oms, azurerm_kubernetes_cluster.aks]
}

# Log Query Alert: API Server Health
resource "azurerm_monitor_scheduled_query_rules_alert" "api_server_health" {
  count               = var.enable_alerts ? 1 : 0
  name                = "${local.aks_cluster_name}-alert-api-health"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  scopes = [azurerm_log_analytics_workspace.oms.id]

  description = "Alert when kube-apiserver is unhealthy"
  severity    = 2
  frequency   = 5
  time_window = 5
  enabled     = true

  criteria {
    query     = "KubePodInventory | where PodName startswith 'kube-apiserver' | summarize by TimeGenerated | count"
    operator  = "LessThan"
    threshold = 1

    metric_trigger {
      operator            = "GreaterThan"
      threshold           = 0
      metric_trigger_type = "Total"
      metric_column       = "Count"
    }
  }

  action {
    action_group {
      action_group_id = azurerm_monitor_action_group.aks_alerts.id
    }
  }

  tags = local.tags
}

# Scheduled Query Rule: Firewall Denied Connections
resource "azurerm_monitor_scheduled_query_rules_log" "firewall_denied_connections" {
  name                = "${local.firewall_primary_name}-denied-connections-query"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  criteria {
    query = "AzureDiagnostics | where Category == 'AzureFirewallNetworkRule' and Action_s == 'Deny' | summarize count() by Action_s"
  }

  data_source_id = azurerm_log_analytics_workspace.oms.id

  tags = local.tags
}
