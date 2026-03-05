# Storage account names must be 3-24 chars, lowercase letters and numbers only
resource "random_string" "sa_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "team4tfstate${random_string.sa_suffix.result}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Prevent accidental deletion of state
  blob_properties {
    versioning_enabled = true
  }

  tags = {
    environment = var.environment
    managed_by  = "terraform"
    team        = "team4"
    purpose     = "terraform-state"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
