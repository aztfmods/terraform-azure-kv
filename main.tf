data "azurerm_client_config" "current" {}

#----------------------------------------------------------------------------------------
# resourcegroups
#----------------------------------------------------------------------------------------

data "azurerm_resource_group" "rg" {
  for_each = var.vaults

  name = each.value.resourcegroup
}

#----------------------------------------------------------------------------------------
# Generate random id
#----------------------------------------------------------------------------------------

resource "random_string" "random" {
  for_each = var.vaults

  length    = 3
  min_lower = 3
  special   = false
  numeric   = false
  upper     = false
}

#----------------------------------------------------------------------------------------
# keyvaults
#----------------------------------------------------------------------------------------

resource "azurerm_key_vault" "keyvault" {
  for_each = var.vaults

  name                = "kv${var.naming.company}${each.key}${var.naming.env}${var.naming.region}${random_string.random[each.key].result}"
  resource_group_name = data.azurerm_resource_group.rg[each.key].name
  location            = data.azurerm_resource_group.rg[each.key].location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = each.value.sku

  enabled_for_deployment          = try(each.value.enable.deployment, true)
  enabled_for_disk_encryption     = try(each.value.enable.disk_encryption, true)
  enabled_for_template_deployment = try(each.value.enable.template_deployment, true)
  purge_protection_enabled        = try(each.value.enable.purge_protection, false)
  enable_rbac_authorization       = try(each.value.enable.rbac_auth, false)
  public_network_access_enabled   = try(each.value.enable.public_network_access, true)
  soft_delete_retention_days      = try(each.value.retention_in_days, null)

  # dynamic "network_acls" {
  #   for_each = var.vaults
  #   # for_each = {
  #   #   for k, v in try(each.value.network_acls, {}) : k => v
  #   # }

  #   content {
  #     default_action             = each.value.network_acls.default_action
  #     bypass                     = each.value.network_acls.bypass
  #     ip_rules                   = try(each.value.network_acls.ip_rules, [])
  #     virtual_network_subnet_ids = try(each.value.network_acls.subnet_ids, [])
  #   }
  # }
}

#----------------------------------------------------------------------------------------
# access policy
#----------------------------------------------------------------------------------------

resource "azurerm_key_vault_access_policy" "policy" {
  for_each = var.vaults

  key_vault_id = azurerm_key_vault.keyvault[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Backup", "Create", "Decrypt", "Delete",
    "Encrypt", "Get", "Import", "List",
    "Purge", "Recover", "Restore", "Sign",
    "UnwrapKey", "Update", "Verify", "WrapKey",
  ]

  secret_permissions = [
    "Backup", "Delete", "Get", "List",
    "Purge", "Recover", "Restore",
    "Set",
  ]

  certificate_permissions = [
    "Backup", "Create", "Delete",
    "DeleteIssuers", "Get", "GetIssuers",
    "Import", "List", "ListIssuers",
    "ManageContacts", "ManageIssuers",
    "Purge", "Recover", "Restore",
    "SetIssuers", "Update",
  ]
}

#----------------------------------------------------------------------------------------
# keyvault keys
#----------------------------------------------------------------------------------------

resource "azurerm_key_vault_key" "kv_keys" {
  for_each = {
    for key in local.keys : "${key.kv_key}.${key.k_key}" => key
  }

  name            = each.value.name
  key_vault_id    = each.value.key_vault_id
  key_type        = each.value.key_type
  key_size        = each.value.key_size
  key_opts        = each.value.key_opts
  curve           = each.value.curve
  not_before_date = each.value.not_before_date
  expiration_date = each.value.expiration_date


  #because of: Status=403 Code="Forbidden" Message="The user, group does not have keys get permission on key vault
  depends_on = [
    azurerm_key_vault_access_policy.policy
  ]
}