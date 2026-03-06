resource "azurerm_container_app_environment" "cae" {
  name                = "cae-team4-${var.environment}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  tags = {
    environment = var.environment
    managed_by  = "terraform"
    team        = "team4"
  }
}
