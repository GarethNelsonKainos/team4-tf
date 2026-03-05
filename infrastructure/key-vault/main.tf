# Get the current Azure client
data "azurerm_client_config" "current" {}

# Reference the existing resource group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# Look up the AAD group that your team belongs to
data "azuread_group" "kv_users" {
  display_name     = var.aad_group_name
  security_enabled = true
}
