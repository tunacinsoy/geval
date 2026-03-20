resource "azurerm_public_ip" "firewall" {
  name                = "${var.prefix}-fw-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = var.firewall_public_ip_sku
}

resource "azurerm_firewall_policy" "main" {
  name                = "${var.prefix}-fw-policy"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_tier            = "Standard"
  threat_intel_mode   = "Alert"

  application_rule_collection {
    name     = "allowed-image-domains"
    priority = 100
    action   = "Allow"
    rule {
      name = "container-registry-allow"
      protocols {
        protocol_type = "Https"
        port          = 443
      }
      source_addresses = var.virtual_network_address_space
      target_fqdns     = var.allowed_domains
    }
  }
}

resource "azurerm_firewall" "main" {
  name                = "${var.prefix}-firewall"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    tier = "Standard"
    name = "AZFW_VNet"
  }

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }

  firewall_policy_id = azurerm_firewall_policy.main.id
}
