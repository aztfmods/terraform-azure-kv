output "vaults" {
  value = azurerm_key_vault.keyvault
}

output "keys" {
  value = azurerm_key_vault_key.keys
}

output "merged_keys" {
  value = values(azurerm_key_vault_key.keys)[*].id
}