# Public IPs for Firewalls
resource "azurerm_public_ip" "firewall_primary" {
  name                = local.firewall_public_ip_primary
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.tags
}

resource "azurerm_public_ip" "firewall_secondary" {
  name                = local.firewall_public_ip_secondary
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.tags
}

# Primary Azure Firewall
resource "azurerm_firewall" "primary" {
  name                = local.firewall_primary_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.firewall_sku_tier
  firewall_policy_id  = azurerm_firewall_policy.egress_control.id

  dns_servers       = []
  dns_proxy_enabled = var.firewall_enable_dns_proxy

  ip_configuration {
    name                 = "${local.firewall_primary_name}-ipconfig"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall_primary.id
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.firewall
  ]

  tags = local.tags
}

# Secondary Azure Firewall (Failover)
resource "azurerm_firewall" "secondary" {
  name                = local.firewall_secondary_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.firewall_sku_tier
  firewall_policy_id  = azurerm_firewall_policy.egress_control.id

  dns_servers       = []
  dns_proxy_enabled = var.firewall_enable_dns_proxy

  ip_configuration {
    name                 = "${local.firewall_secondary_name}-ipconfig"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall_secondary.id
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.firewall,
    azurerm_firewall.primary
  ]

  tags = local.tags
}

# Firewall Policy (Allow-list model)
resource "azurerm_firewall_policy" "egress_control" {
  name                = local.firewall_policy_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  # IDPS: Intrusion Detection and Prevention System (Premium feature)
  threat_intelligence_mode = "Alert"
  threat_intelligence_allowlist {
    ip_addresses = []
    fqdns        = []
  }

  # DNS Proxy settings
  dns {
    servers = []
  }

  tags = local.tags
}

# Firewall Policy Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "allow_registries" {
  name               = "${local.firewall_policy_name}-allow-registries"
  firewall_policy_id = azurerm_firewall_policy.egress_control.id
  priority           = 100

  # Application Rule Collection: Allow docker.io and ubuntu.com
  application_rule_collection {
    name     = "allow-registries"
    priority = 100
    action   = "Allow"

    # Allow docker.io (container image registry)
    rule {
      name             = "allow-docker-io"
      source_addresses = [var.node_subnet_cidr]
      destination_fqdns = [
        "*.docker.io",
        "docker.io",
        "*.docker.com",
        "docker.com"
      ]
      protocols {
        type = "Https"
        port = 443
      }
    }

    # Allow ubuntu.com (package repositories)
    rule {
      name             = "allow-ubuntu-com"
      source_addresses = [var.node_subnet_cidr]
      destination_fqdns = [
        "*.ubuntu.com",
        "ubuntu.com",
        "*.canonical.com",
        "canonical.com"
      ]
      protocols {
        type = "Https"
        port = 443
      }
    }

    # Allow Microsoft services for AKS updates
    rule {
      name             = "allow-microsoft-updates"
      source_addresses = [var.node_subnet_cidr]
      destination_fqdns = [
        "*.api.cdktf.io",
        "*.microsoft.com",
        "*.msft.net",
        "*.windows.net"
      ]
      protocols {
        type = "Https"
        port = 443
      }
    }
  }

  # Deny all by default (implicit deny at end of rule collection)
}

# User-Defined Route (UDR) for Node Egress to Firewall
resource "azurerm_route_table" "node_egress" {
  name                          = local.udr_node_egress_name
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  disable_bgp_route_propagation = false

  tags = local.tags
}

# Primary Route: Direct all egress to Primary Firewall
resource "azurerm_route" "primary_firewall" {
  name                   = "${local.udr_node_egress_name}-primary"
  resource_group_name    = data.azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.node_egress.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.primary.ip_configuration[0].private_ip_address

  depends_on = [azurerm_firewall.primary]
}

# Associate UDR with Node Subnet
resource "azurerm_subnet_route_table_association" "node" {
  subnet_id      = azurerm_subnet.node.id
  route_table_id = azurerm_route_table.node_egress.id
}

# Diagnostic Settings: Firewall Logging to Storage Account
resource "azurerm_monitor_diagnostic_setting" "firewall_primary" {
  name                       = "${local.firewall_primary_name}-diag"
  target_resource_id         = azurerm_firewall.primary.id
  storage_account_id         = azurerm_storage_account.firewall_logs.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.oms.id

  enabled_log {
    category = "AzureFirewallApplicationRule"
  }

  enabled_log {
    category = "AzureFirewallNetworkRule"
  }

  enabled_log {
    category = "AzureFirewallDnsProxy"
  }

  metric {
    category = "AllMetrics"
  }

  depends_on = [azurerm_firewall.primary, azurerm_storage_account.firewall_logs]
}

resource "azurerm_monitor_diagnostic_setting" "firewall_secondary" {
  name                       = "${local.firewall_secondary_name}-diag"
  target_resource_id         = azurerm_firewall.secondary.id
  storage_account_id         = azurerm_storage_account.firewall_logs.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.oms.id

  enabled_log {
    category = "AzureFirewallApplicationRule"
  }

  enabled_log {
    category = "AzureFirewallNetworkRule"
  }

  enabled_log {
    category = "AzureFirewallDnsProxy"
  }

  metric {
    category = "AllMetrics"
  }

  depends_on = [azurerm_firewall.secondary, azurerm_storage_account.firewall_logs]
}
