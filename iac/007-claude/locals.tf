locals {
  # Naming convention: {naming_prefix}-{component}-{project_name}-{environment}
  # Example: 001-vnet-private-aks-prod

  resource_group_name = data.azurerm_resource_group.rg.name

  # VNet and Networking Resources
  vnet_name                    = "${var.naming_prefix}-vnet-${var.project_name}-${var.environment}"
  control_plane_subnet_name    = "${var.naming_prefix}-subnet-control-plane-${var.environment}"
  node_subnet_name             = "${var.naming_prefix}-subnet-nodes-${var.environment}"
  firewall_subnet_name         = "AzureFirewallSubnet" # Required name by Azure
  private_endpoint_subnet_name = "${var.naming_prefix}-subnet-pep-${var.environment}"

  # Network Security Groups
  control_plane_nsg_name = "${var.naming_prefix}-nsg-control-plane-${var.environment}"
  node_subnet_nsg_name   = "${var.naming_prefix}-nsg-nodes-${var.environment}"
  firewall_nsg_name      = "${var.naming_prefix}-nsg-firewall-${var.environment}"

  # Firewall Resources
  firewall_primary_name        = "${var.naming_prefix}-fw-primary-${var.project_name}-${var.environment}"
  firewall_secondary_name      = "${var.naming_prefix}-fw-secondary-${var.project_name}-${var.environment}"
  firewall_policy_name         = "${var.naming_prefix}-policy-egress-control-${var.environment}"
  firewall_public_ip_primary   = "${var.naming_prefix}-pip-fw-primary-${var.environment}"
  firewall_public_ip_secondary = "${var.naming_prefix}-pip-fw-secondary-${var.environment}"
  udr_node_egress_name         = "${var.naming_prefix}-udr-node-egress-${var.environment}"

  # AKS Resources
  aks_cluster_name          = "${var.naming_prefix}-aks-${var.project_name}-${var.environment}"
  aks_node_resource_group   = "mc-${local.resource_group_name}-${local.aks_cluster_name}"
  aks_private_endpoint_name = "${var.naming_prefix}-pep-aks-cp-${var.environment}"
  aks_managed_identity_name = "${var.naming_prefix}-mi-aks-${var.environment}"

  # Key Vault
  key_vault_name = "${var.naming_prefix}-kv-${var.project_name}-${var.environment}"

  # Monitoring Resources
  log_analytics_workspace_name  = "${var.naming_prefix}-oms-${var.project_name}-${var.environment}"
  storage_account_firewall_logs = replace("st${var.naming_prefix}fwlogs${var.environment}", "-", "")
  action_group_name             = "${var.naming_prefix}-ag-${var.project_name}-alerts-${var.environment}"

  # DNS
  aks_private_dns_zone_name = "cluster.privatelink.${var.location}.azmk8s.io"

  # Kubernetes Configuration
  kubernetes_service_cidr = "172.17.0.0/16"
  dns_service_ip          = "172.17.0.10"
  docker_bridge_cidr      = "172.18.0.0/16"

  # Merging tags
  tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Location    = var.location
    }
  )
}
