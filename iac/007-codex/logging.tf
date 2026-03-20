resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
}

resource "azurerm_storage_account" "logs" {
  name                     = "${var.prefix}logs${var.environment}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  access_tier              = "Hot"
  allow_blob_public_access = false
  enable_https_traffic_only = true

  network_rules {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = [azurerm_subnet.aks.id]
  }
}

resource "azurerm_storage_container" "firewall_logs" {
  name                  = "firewall-logs"
  storage_account_name  = azurerm_storage_account.logs.name
  container_access_type = "private"
}

resource "azurerm_monitor_diagnostic_setting" "firewall" {
  name                       = "${var.prefix}-fw-diag"
  target_resource_id         = azurerm_firewall.main.id
  storage_account_id         = azurerm_storage_account.logs.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true
    retention_policy {
      enabled = true
      days    = var.log_retention_days
    }
  }

  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true
    retention_policy {
      enabled = true
      days    = var.log_retention_days
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = true
      days    = var.log_retention_days
    }
  }
}
