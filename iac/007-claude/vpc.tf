# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  address_space       = [var.vnet_cidr]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  tags = local.tags
}

# Control Plane Subnet (Private, no public route)
resource "azurerm_subnet" "control_plane" {
  name                 = local.control_plane_subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.control_plane_subnet_cidr]

  service_endpoints = ["Microsoft.Storage"]

  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies  = false
}

# Node Subnet (Private, with UDR to firewall)
resource "azurerm_subnet" "node" {
  name                 = local.node_subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.node_subnet_cidr]

  service_endpoints = ["Microsoft.Storage"]

  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies  = false
}

# Firewall Subnet (Required: must be named AzureFirewallSubnet)
resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.firewall_subnet_cidr]

  # Firewall subnet does not need private endpoint enforcement
}

# Private Endpoint Subnet
resource "azurerm_subnet" "private_endpoint" {
  name                 = local.private_endpoint_subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.private_endpoint_subnet_cidr]

  service_endpoints = ["Microsoft.Storage"]

  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = false
}

# Network Security Groups

resource "azurerm_network_security_group" "control_plane" {
  name                = local.control_plane_nsg_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  # Inbound: Allow from Node subnet (10.0.10.0/22) on 443 (kubelet)
  security_rule {
    name                       = "AllowNodeSubnetPort443"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.node_subnet_cidr
    destination_address_prefix = "*"
  }

  # Inbound: Allow from Private Endpoint subnet on 443
  security_rule {
    name                       = "AllowPrivateEndpointPort443"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.private_endpoint_subnet_cidr
    destination_address_prefix = "*"
  }

  # Inbound: Deny all others (default deny)
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Outbound: Allow all (control plane initiates)
  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.tags
}

resource "azurerm_network_security_group" "node" {
  name                = local.node_subnet_nsg_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  # Inbound: Allow within cluster CIDR (10.0.0.0/16) for pod communication
  security_rule {
    name                       = "AllowClusterCIDRInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.vnet_cidr
    destination_address_prefix = "*"
  }

  # Inbound: Deny all others
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Outbound: Allow to Firewall subnet (traffic routed via UDR)
  security_rule {
    name                       = "AllowFirewallSubnetOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = var.firewall_subnet_cidr
  }

  # Outbound: Allow within cluster CIDR
  security_rule {
    name                       = "AllowClusterCIDROutbound"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = var.vnet_cidr
  }

  # Outbound: Deny all others
  security_rule {
    name                       = "DenyAllOutbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.tags
}

resource "azurerm_network_security_group" "firewall" {
  name                = local.firewall_nsg_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  # Inbound: Allow from VNet
  security_rule {
    name                       = "AllowVNetInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.vnet_cidr
    destination_address_prefix = "*"
  }

  # Outbound: Allow all (firewall needs to reach registries)
  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.tags
}

# Associate NSGs with subnets
resource "azurerm_subnet_network_security_group_association" "control_plane" {
  subnet_id                 = azurerm_subnet.control_plane.id
  network_security_group_id = azurerm_network_security_group.control_plane.id
}

resource "azurerm_subnet_network_security_group_association" "node" {
  subnet_id                 = azurerm_subnet.node.id
  network_security_group_id = azurerm_network_security_group.node.id
}

resource "azurerm_subnet_network_security_group_association" "firewall" {
  subnet_id                 = azurerm_subnet.firewall.id
  network_security_group_id = azurerm_network_security_group.firewall.id
}

# Private Endpoint for AKS Control Plane
resource "azurerm_private_endpoint" "aks_control_plane" {
  name                = local.aks_private_endpoint_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = "${local.aks_private_endpoint_name}-connection"
    private_connection_resource_id = azurerm_kubernetes_cluster.aks.id
    subresource_names              = ["management"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = local.aks_private_dns_zone_name
    private_dns_zone_ids = [azurerm_private_dns_zone.aks.id]
  }

  depends_on = [azurerm_kubernetes_cluster.aks]

  tags = local.tags
}

# Private DNS Zone for AKS Control Plane
resource "azurerm_private_dns_zone" "aks" {
  name                = local.aks_private_dns_zone_name
  resource_group_name = data.azurerm_resource_group.rg.name

  tags = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks" {
  name                  = "${local.aks_private_dns_zone_name}-link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = azurerm_virtual_network.vnet.id

  tags = local.tags
}
