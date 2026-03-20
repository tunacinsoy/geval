# Azure Key Vault for Secrets Management
resource "azurerm_key_vault" "kv" {
  name                            = local.key_vault_name
  location                        = data.azurerm_resource_group.rg.location
  resource_group_name             = data.azurerm_resource_group.rg.name
  enabled_for_disk_encryption     = false
  enabled_for_deployment          = false
  enabled_for_template_deployment = false
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = "standard"
  purge_protection_enabled        = true
  soft_delete_retention_days      = 90

  # Enable access for current user/principal to manage secrets
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set"
    ]

    key_permissions = [
      "Backup",
      "Create",
      "Delete",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey"
    ]
  }

  network_rules {
    bypass                     = ["AzureServices"]
    default_action             = "Allow" # Can be restricted to "Deny" with whitelist IPs
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  tags = local.tags
}

# User-Assigned Managed Identity for AKS
resource "azurerm_user_assigned_identity" "aks" {
  name                = local.aks_managed_identity_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  tags = local.tags
}

# Role Assignment: Contributor on Resource Group (for AKS to manage resources)
resource "azurerm_role_assignment" "aks_contributor" {
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

# Role Assignment: Key Vault Secret User (for AKS to read secrets)
resource "azurerm_role_assignment" "aks_key_vault_secrets" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

# Role Assignment: Storage Account Contributor (for firewall logs access)
resource "azurerm_role_assignment" "aks_storage_logs" {
  scope                = azurerm_storage_account.firewall_logs.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

# Access Policy for AKS Managed Identity in Key Vault
resource "azurerm_key_vault_access_policy" "aks" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.aks.principal_id

  secret_permissions = [
    "Get",
    "List"
  ]

  depends_on = [azurerm_key_vault.kv]
}
