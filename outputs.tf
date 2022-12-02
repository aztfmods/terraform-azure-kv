output "vaults" {
  value = azurerm_key_vault.keyvault
}

output "kv_keys" {
  value = azurerm_key_vault_key.kv_keys
}

# output "kv_keys" {
#   value = flatten([for m in var.module_ids :
#     [for k, v in m : v]
#   ])
# }