output "vaults" {
  value = azurerm_key_vault.keyvault
}

output "kv_keys" {
  value = tostring(azurerm_key_vault_key.kv_keys)
}