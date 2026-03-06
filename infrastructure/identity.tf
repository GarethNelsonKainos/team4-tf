resource "azurerm_user_assigned_identity" "managed_identity" {
  name                = "id-team4-${var.environment}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  tags = {
    environment = var.environment
    managed_by  = "terraform"
    team        = "team4"
  }
}

# Allow the identity to read secrets from Key Vault
resource "azurerm_role_assignment" "identity_kv_secrets_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.managed_identity.principal_id
}

# Allow the identity to pull images from ACR
resource "azurerm_role_assignment" "identity_acr_pull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.managed_identity.principal_id
}
