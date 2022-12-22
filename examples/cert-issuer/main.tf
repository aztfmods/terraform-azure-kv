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

      issuer = {
        digicert = {
          org_id        = "12345"
          provider_name = "DigiCert"
          account_id    = "12345"
          password      = "12345"
        }
      }
    }
  }
  depends_on = [module.global]
}