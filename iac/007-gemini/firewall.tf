resource "azurerm_public_ip" "firewall" {
  name                = "${var.prefix}-fw-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "main" {
  name                = "${var.prefix}-fw"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

resource "azurerm_firewall_policy" "main" {
  name                = "${var.prefix}-fw-policy"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_firewall_policy_rule_collection_group" "main" {
  name               = "default-application-rules"
  firewall_policy_id = azurerm_firewall_policy.main.id
  priority           = 200

  application_rule_collection {
    name     = "docker"
    priority = 200
    action   = "Allow"

    rule {
      name = "docker"
      source_addresses = [
        "*",
      ]
      destination_fqdns = [
        "*.docker.io",
      ]
      protocols {
        type = "Https"
        port = 443
      }
    }
  }

  application_rule_collection {
    name     = "ubuntu"
    priority = 201
    action   = "Allow"

    rule {
      name = "ubuntu"
      source_addresses = [
        "*",
      ]
      destination_fqdns = [
        "*.ubuntu.com",
      ]
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
    }
  }
}

resource "azurerm_firewall_policy_attachment" "main" {
  name               = "default"
  firewall_policy_id = azurerm_firewall_policy.main.id
  firewall_id        = azurerm_firewall.main.id
}
