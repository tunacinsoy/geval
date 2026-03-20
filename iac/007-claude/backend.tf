terraform {
  backend "azurerm" {
    # Configure these values via -backend-config during terraform init or in backend config file
    # Example: terraform init -backend-config="resource_group_name=rg-terraform" \
    #                         -backend-config="storage_account_name=tfstateaccountname" \
    #                         -backend-config="container_name=tfstate" \
    #                         -backend-config="key=aks-001-prod.tfstate"

    # Backend configuration:
    # - storage_account_name: Azure Storage Account for state
    # - container_name: Blob Container (must exist)
    # - key: State file name (e.g., aks-001-prod.tfstate)
    # - resource_group_name: Resource Group containing storage account
    # - use_azuread_auth: true (recommended, use managed identity)
  }
}
