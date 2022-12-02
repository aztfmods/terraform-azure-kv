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

      keys = {
        demo = {
          key_type = "RSA"
          key_size = 2048
          key_opts = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
        }
      }
    }
  }
  depends_on = [module.global]
}