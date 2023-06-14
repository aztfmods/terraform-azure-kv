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
  source = "github.com/aztfmods/module-azurerm-kv"

  workload       = var.workload
  environment    = var.environment
  location_short = module.region.location_short

  vault = {
    location      = module.rg.group.location
    resourcegroup = module.rg.group.name

    secrets = {
      random_string = {
        example1 = {
          length  = 24
          special = false
        }
      }
      tls_public_key = {
        example2 = {
          algorithm = "RSA"
          rsa_bits  = 2048
        }
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
