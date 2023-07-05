provider "azurerm" {
  features {}
}

module "logging" {
  source = "github.com/aztfmods/module-azurerm-law?ref=v0.0.1"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  laws = {
    diags = {
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name
      sku           = "PerGB2018"
      retention     = 30
    }
  }
  depends_on = [module.global]
}

module "kv" {
  source = "github.com/aztfmods/terraform-azure-kv?ref=v1.8.0"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vaults = {
    demo = {
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name
      sku           = "standard"
    }
  }
  depends_on = [module.global]
}

module "diagnostic_settings" {
  source = "github.com/aztfmods/module-azurerm-diags?ref=v0.0.1"
  count  = length(module.kv.merged_ids)

  resource_id           = element(module.kv.merged_ids, count.index)
  logs_destinations_ids = [lookup(module.logging.laws.diags, "id", null)]
}
