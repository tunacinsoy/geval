resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.prefix}-aks"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "${var.prefix}-aks"
  private_cluster_enabled = true

  default_node_pool {
    name       = "default"
    vm_size    = "Standard_D4s_v5"
    node_count = 3
    vnet_subnet_id = azurerm_subnet.aks.id
    enable_auto_scaling = true
    max_count = 5
    min_count = 3
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    load_balancer_sku = "standard"
  }

  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }
}
