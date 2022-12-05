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

locals {
  secrets = flatten([
    for kv_key, kv in var.vaults : [
      for secret_key, secret in try(kv.secrets, {}) : {

        kv_key       = kv_key
        secret_key   = secret_key
        name         = secret_key
        length       = secret.length
        special      = try(secret.special, true)
        min_lower    = try(secret.min_lower, 5)
        min_upper    = try(secret.min_upper, 7)
        min_special  = try(secret.min_special, 4)
        min_numeric  = try(secret.min_numeric, 5)
        key_vault_id = azurerm_key_vault.keyvault[kv_key].id
      }
    ]
  ])
}