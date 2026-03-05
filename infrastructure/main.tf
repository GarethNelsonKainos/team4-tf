# Get the current Azure client
data "azurerm_client_config" "current" {}

# Reference the existing resource group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}


