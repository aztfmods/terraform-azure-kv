provider "azurerm" {
  features {}
}

module "region" {
  source = "github.com/aztfmods/module-azurerm-regions"

  workload    = var.workload
  environment = var.environment

  location = "westeurope"
}

module "rg" {
  source = "github.com/aztfmods/module-azurerm-rg"

  workload       = var.workload
  environment    = var.environment
  location_short = module.region.location_short
  location       = module.region.location
}

module "kv" {
  source = "../../"

  workload       = var.workload
  environment    = var.environment
  location_short = module.region.location_short

  vault = {
    location      = module.rg.group.location
    resourcegroup = module.rg.group.name

    issuers = {
      digicert = {
        org_id        = "12345"
        provider_name = "DigiCert"
        account_id    = "12345"
        password      = "12345"
      }
    }

    contacts = {
      admin = {
        email = "dummy@cloudnation.nl"
      }
    }
  }
  depends_on = [module.rg]
}

