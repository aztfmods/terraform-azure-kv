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
  enable_rbac_authorization       = try(each.value.enable.rbac_auth, true)
  public_network_access_enabled   = try(each.value.enable.public_network_access, true)
  soft_delete_retention_days      = try(each.value.retention_in_days, null)

  dynamic "network_acls" {
    for_each = {
      for k, v in try(each.value.network_acls, {}) : k => v
    }

    content {
      default_action             = each.value.default_action
      bypass                     = each.value.bypass
      ip_rules                   = try(each.value.ip_rules, [])
      virtual_network_subnet_ids = try(each.value.subnet_ids, [])
    }
  }
}