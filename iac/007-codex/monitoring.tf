resource "azurerm_monitor_action_group" "alerts" {
  name                = "${var.prefix}-alerts"
  resource_group_name = var.resource_group_name
  short_name          = "PRIVAKS"
  location            = var.location

  email_receiver {
    name                     = "platform-ops"
    email_address            = "platform-ops@example.com"
    use_common_alert_schema  = true
  }
}

resource "azurerm_monitor_metric_alert" "node_health" {
  name                = "${var.prefix}-node-health"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_kubernetes_cluster.main.id]
  description         = "Alert when AKS node availability drops below 2"
  severity            = 2
  enabled             = true
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "AvailableNodes"
    aggregation      = "Minimum"
    operator         = "LessThan"
    threshold        = 2
  }

  action {
    action_group_id = azurerm_monitor_action_group.alerts.id
  }
}
