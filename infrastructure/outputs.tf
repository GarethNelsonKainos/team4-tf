output "key_vault_id" {
  description = "The Azure resource ID of the Key Vault"
  value       = azurerm_key_vault.kv.id
}

output "key_vault_uri" {
  description = "The URI of the Key Vault (used by apps to connect)"
  value       = azurerm_key_vault.kv.vault_uri
}

output "key_vault_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.kv.name
}
