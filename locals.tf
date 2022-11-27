locals {
  access_admin = flatten([
    for vault_key, vault in var.vaults : [
      for pol_key, pol in try(vault.access_policy.admin.groups, {}) : {

        vault_key    = vault_key
        pol_key      = pol_key
        key_vault_id = azurerm_key_vault.keyvault[vault_key].id
        display_name = pol
        grant_access_to_groups = false
      }
    ]
  ])
}

locals {
  access_reader = flatten([
    for vault_key, vault in var.vaults : [
      for pol_key, pol in try(vault.access_policy.reader.groups, {}) : {

        vault_key    = vault_key
        pol_key      = pol_key
        key_vault_id = azurerm_key_vault.keyvault[vault_key].id
        display_name = pol
      }
    ]
  ])
}