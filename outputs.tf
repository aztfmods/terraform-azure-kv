output "vaults" {
  value = azurerm_key_vault.keyvault
}

output "keys" {
  value = azurerm_key_vault_key.kv_keys
}