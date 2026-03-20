resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.prefix}-aks"
  kubernetes_version  = var.aks_version
  private_cluster_enabled = true
  public_network_access_enabled = false
  api_server_authorized_ip_ranges = []
  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    load_balancer_sku  = "standard"
    outbound_type      = "userDefinedRouting"
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
    }
  }

  default_node_pool {
    name               = "primary"
    vm_size            = var.node_vm_size
    node_count         = var.node_count
    max_count          = var.node_pool_max
    availability_zones = var.node_zones
    vnet_subnet_id     = azurerm_subnet.aks.id
    enable_node_public_ip = false
    type = "VirtualMachineScaleSets"
    mode = "System"
  }

  depends_on = [
    azurerm_firewall.main,
    azurerm_route_table.egress,
  ]
}
