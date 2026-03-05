# Random suffix ensures the Key Vault name is globally unique
resource "random_string" "kv_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_key_vault" "kv" {
  name                       = "kv-${var.environment}-${random_string.kv_suffix.result}"
  location                   = data.azurerm_resource_group.rg.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.sku_name
  enable_rbac_authorization  = true
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = false

  tags = {
    environment = var.environment
    managed_by  = "terraform"
    team        = "team4"
  }
}

# Grants the whole team read/write access to secrets
resource "azurerm_role_assignment" "kv_secrets_officer" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.aad_group_object_id
}

# IMPORTANT: The pipeline service principal must have "Key Vault Secrets User"
# on this Key Vault. Assign manually via CLI before deploying anything that reads secrets:
#
#   az role assignment create --assignee "<pipeline-sp-object-id>" \
#     --role "Key Vault Secrets User" \
#     --scope "<key-vault-resource-id>"
