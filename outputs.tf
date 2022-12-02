output "vaults" {
  value = azurerm_key_vault.keyvault
}

output "vault_keys" {
  value = azurerm_key_vault_key.generated
}