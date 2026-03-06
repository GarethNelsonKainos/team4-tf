# Current Azure client (used for tenant_id etc.)
data "azurerm_client_config" "current" {}

# Existing resource group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# Existing ACR (owned by the BE repo — referenced here for role assignments)
data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.acr_resource_group_name
}

# Key Vault secrets (set manually in Azure Portal or CLI — not managed by Terraform)
data "azurerm_key_vault_secret" "database_url" {
  name         = "database-url"
  key_vault_id = azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "jwt_secret" {
  name         = "jwt-secret"
  key_vault_id = azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "postgres_password" {
  name         = "postgres-password"
  key_vault_id = azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "aws_access_key_id" {
  name         = "aws-access-key-id"
  key_vault_id = azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "aws_secret_access_key" {
  name         = "aws-secret-access-key"
  key_vault_id = azurerm_key_vault.kv.id
}
