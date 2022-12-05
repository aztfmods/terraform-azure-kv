provider "azurerm" {
  features {}
}

locals {
  naming = {
    company = "cn"
    env     = "p"
    region  = "weu"
  }
}

module "global" {
  source = "github.com/aztfmods/module-azurerm-global"
  rgs = {
    vault = {
      name     = "rg-${local.naming.company}-kv-${local.naming.env}-${local.naming.region}"
      location = "westeurope"
    }
  }
}

module "kv" {
  source = "../../"

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

  vaults = {
    demo = {
      location      = module.global.groups.vault.location
      resourcegroup = module.global.groups.vault.name
      sku           = "standard"

      enable = {
        rbac_auth = true
      }

      certs = {
        demo = {
        issuer = "Self", subject = "CN=app1.demo.org", validity_in_months = 12, exportable = true }
      }
    }
  }
  depends_on = [module.global]
}