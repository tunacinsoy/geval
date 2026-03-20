# Azure Kubernetes Service (AKS) Cluster - Private
resource "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_cluster_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = local.aks_cluster_name
  kubernetes_version  = var.kubernetes_version

  # Node resource group (auto-managed by Azure)
  node_resource_group = "mc-${data.azurerm_resource_group.rg.name}-${local.aks_cluster_name}"

  # Network Configuration
  network_profile {
    network_plugin      = "azure"
    network_policy      = "azure"
    network_plugin_mode = "overlay"
    pod_cidr            = "192.168.0.0/16" # Overlay mode pod CIDR
    service_cidr        = local.kubernetes_service_cidr
    dns_service_ip      = local.dns_service_ip
    docker_bridge_cidr  = local.docker_bridge_cidr
    outbound_type       = "userDefinedRouting" # Use UDR (firewall routing)
    load_balancer_sku   = "standard"
  }

  # Default Node Pool
  default_node_pool {
    name                  = "systempool"
    node_count            = var.aks_node_count
    vm_size               = var.aks_vm_size
    os_disk_size_gb       = var.aks_os_disk_size_gb
    os_disk_type          = "Premium_LRS"
    vnet_subnet_id        = azurerm_subnet.node.id
    max_pods              = var.aks_max_pods_per_node
    enable_node_public_ip = false
    enable_auto_scaling   = var.aks_enable_auto_scaling
    min_count             = var.aks_enable_auto_scaling ? 1 : null
    max_count             = var.aks_enable_auto_scaling ? 10 : null
    availability_zones    = var.availability_zones

    node_labels = {
      "nodepool"    = "system"
      "managed"     = "terraform"
      "environment" = var.environment
    }

    node_taints = [
      {
        key    = "system"
        value  = "true"
        effect = "NoSchedule"
      }
    ]

    tags = local.tags
  }

  # Identity Configuration (User-Assigned Managed Identity)
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  # Kubelet Identity (for AKS system operations)
  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.aks.client_id
    object_id                 = azurerm_user_assigned_identity.aks.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.aks.id
  }

  # API Server Access Configuration (Private)
  api_server_access_profile {
    authorized_ip_ranges   = [] # Private cluster only, no authorized IPs
    enable_private_cluster = true
  }

  # Enable RBAC and Azure AD Integration
  role_based_access_control_enabled = true

  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  # OMS Agent for Monitoring
  oms_agent {
    log_analytics_workspace_id      = azurerm_log_analytics_workspace.oms.id
    msi_auth_for_monitoring_enabled = true
  }

  # Automatic Upgrades
  auto_scaler_profile {
    balance_similar_node_groups      = false
    expander                         = "random"
    max_graceful_termination_sec     = 600
    max_node_provision_time          = "15m"
    max_total_unready_percentage     = 45
    new_pod_scale_down_enabled       = false
    scale_down_delay_after_add       = "10m"
    scale_down_delay_after_delete    = "10s"
    scale_down_delay_after_failure   = "3m"
    scale_down_unneeded              = "10m"
    scale_down_unready               = "20m"
    scale_down_utilization_threshold = "0.5"
  }

  # Tags
  tags = local.tags

  # Dependencies
  depends_on = [
    azurerm_subnet.node,
    azurerm_user_assigned_identity.aks,
    azurerm_role_assignment.aks_contributor,
    azurerm_key_vault.kv,
    azurerm_log_analytics_workspace.oms
  ]
}

# Diagnostic Settings for AKS Cluster
resource "azurerm_monitor_diagnostic_setting" "aks" {
  name                       = "${local.aks_cluster_name}-diag"
  target_resource_id         = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.oms.id

  # Control Plane Logs
  enabled_log {
    category = "kube-apiserver"
  }

  enabled_log {
    category = "kube-audit"
  }

  enabled_log {
    category = "kube-controller-manager"
  }

  enabled_log {
    category = "kube-scheduler"
  }

  enabled_log {
    category = "cluster-autoscaler"
  }

  enabled_log {
    category = "guard"
  }

  # Metrics
  metric {
    category = "AllMetrics"
  }

  depends_on = [azurerm_kubernetes_cluster.aks, azurerm_log_analytics_workspace.oms]
}
