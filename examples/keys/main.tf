provider "azurerm" {
  features {}
}

module "global" {
  source = "github.com/aztfmods/module-azurerm-global"

  company = "cn"
  env     = "p"
  region  = "weu"

  rgs = {
    demo = { location = "westeurope" }
  }
}

module "kv" {
  source = "../../"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vaults = {
    demo = {
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name
      sku           = "standard"

      enable = {
        rbac_auth = true
      }

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