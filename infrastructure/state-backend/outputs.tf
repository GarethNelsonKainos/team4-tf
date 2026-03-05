output "storage_account_name" {
  description = "Storage account name — use this in each module's backend config"
  value       = azurerm_storage_account.tfstate.name
}

output "container_name" {
  description = "Blob container name — use this in each module's backend config"
  value       = azurerm_storage_container.tfstate.name
}

output "resource_group_name" {
  description = "Resource group the storage account lives in"
  value       = data.azurerm_resource_group.rg.name
}
