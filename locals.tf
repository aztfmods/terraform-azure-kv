locals {
  keys = flatten([
    for kv_key, kv in var.vaults : [
      for k_key, k in try(kv.keys, {}) : {

        kv_key          = kv_key
        k_key           = k_key
        name            = k_key
        key_type        = k.key_type
        key_opts        = k.key_opts
        key_size        = try(k.key_size, null)
        curve           = try(k.curve, null)
        not_before_date = try(k.not_before_date, null)
        expiration_date = try(k.expiration_date, null)
        key_vault_id    = azurerm_key_vault.keyvault[kv_key].id
      }
    ]
  ])
}