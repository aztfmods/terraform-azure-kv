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

      certs = {
        demo = {
        issuer = "Self", subject = "CN=app1.demo.org", validity_in_months = 12, exportable = true }
      }

      contacts = {
        admin = {
          email = "dennis.kool@cloudnation.nl"
        }
      }
    }
  }
  depends_on = [module.global]
}