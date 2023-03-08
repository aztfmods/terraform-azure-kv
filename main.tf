data "azurerm_client_config" "current" {}

#----------------------------------------------------------------------------------------
# Generate random id
#----------------------------------------------------------------------------------------

resource "random_string" "random" {
  length    = 3
  min_lower = 3
  special   = false
  numeric   = false
  upper     = false
}

#----------------------------------------------------------------------------------------
# keyvault
#----------------------------------------------------------------------------------------

resource "azurerm_key_vault" "keyvault" {
  name                = "kv${var.company}${var.env}${var.region}${random_string.random.result}"
  resource_group_name = var.vault.resourcegroup
  location            = var.vault.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = try(var.vault.sku, "standard")

  enabled_for_deployment          = try(var.vault.enable.deployment, true)
  enabled_for_disk_encryption     = try(var.vault.enable.disk_encryption, true)
  enabled_for_template_deployment = try(var.vault.enable.template_deployment, true)
  purge_protection_enabled        = try(var.vault.enable.purge_protection, true)
  enable_rbac_authorization       = try(var.vault.enforce_rbac_auth, true)
  public_network_access_enabled   = try(var.vault.enable.public_network_access, true)
  soft_delete_retention_days      = try(var.vault.retention_in_days, null)

  # dynamic "network_acls" {
  #   for_each = var.vault
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

  lifecycle {
    ignore_changes = [
      contact,
    ]
  }
}

#----------------------------------------------------------------------------------------
# role assignments
#----------------------------------------------------------------------------------------

resource "azurerm_role_assignment" "current" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}


#----------------------------------------------------------------------------------------
# certificate issuers
#----------------------------------------------------------------------------------------

resource "azurerm_key_vault_certificate_issuer" "issuer" {
  for_each = {
    for issuer in local.issuers : issuer.issuer_key => issuer
  }

  name          = each.value.name
  org_id        = each.value.org_id
  key_vault_id  = each.value.key_vault_id
  provider_name = each.value.provider_name
  account_id    = each.value.account_id
  password      = each.value.password //pat certificate authority

  depends_on = [
    azurerm_role_assignment.current
  ]
}

#----------------------------------------------------------------------------------------
# certificate contacts
#----------------------------------------------------------------------------------------

resource "azurerm_key_vault_certificate_contacts" "example" {
  key_vault_id = azurerm_key_vault.keyvault.id

  dynamic "contact" {
    for_each = {
      for k, v in try(var.vault.contacts, {}) : k => v
    }

    content {
      email = contact.value.email
      name  = try(contact.value.name, null)
      phone = try(contact.value.phone, null)
    }
  }

  depends_on = [
    azurerm_role_assignment.current
  ]
}

#----------------------------------------------------------------------------------------
# keys
#----------------------------------------------------------------------------------------

resource "azurerm_key_vault_key" "kv_keys" {
  for_each = {
    for key in local.keys : key.k_key => key
  }

  name            = each.value.name
  key_vault_id    = each.value.key_vault_id
  key_type        = each.value.key_type
  key_size        = each.value.key_size
  key_opts        = each.value.key_opts
  curve           = each.value.curve
  not_before_date = each.value.not_before_date
  expiration_date = each.value.expiration_date

  depends_on = [
    azurerm_role_assignment.current
  ]
}

#----------------------------------------------------------------------------------------
# secrets
#----------------------------------------------------------------------------------------

resource "random_password" "password" {
  for_each = {
    for secret in local.secrets : secret.secret_key => secret
  }

  length      = each.value.length
  special     = each.value.special
  min_lower   = each.value.min_lower
  min_upper   = each.value.min_upper
  min_special = each.value.min_special
  min_numeric = each.value.min_numeric
}

resource "azurerm_key_vault_secret" "secret" {
  for_each = {
    for secret in local.secrets : secret.secret_key => secret
  }

  name         = each.value.name
  value        = random_password.password[each.key].result
  key_vault_id = each.value.key_vault_id

  depends_on = [
    azurerm_role_assignment.current
  ]
}

# ----------------------------------------------------------------------------------------
# certificates
# ----------------------------------------------------------------------------------------

resource "azurerm_key_vault_certificate" "cert" {
  for_each = {
    for cert in local.certs : cert.cert_key => cert
  }

  name         = each.value.name
  key_vault_id = each.value.key_vault_id

  certificate_policy {
    issuer_parameters {
      name = each.value.issuer
    }
    key_properties {
      exportable = each.value.issuer == "Self" ? true : false
      key_type   = each.value.key_type
      key_size   = each.value.key_size
      reuse_key  = each.value.reuse_key
    }
    secret_properties {
      content_type = each.value.content_type
    }
    x509_certificate_properties {
      subject            = each.value.subject
      validity_in_months = each.value.validity_in_months
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]
    }
  }
  depends_on = [
    azurerm_role_assignment.current
  ]
}
