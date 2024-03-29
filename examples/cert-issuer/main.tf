provider "azurerm" {
  features {}
}

module "rg" {
  source = "github.com/aztfmods/terraform-azure-rg?ref=v0.0.1"

  environment = var.environment

  groups = {
    demo = {
      region = "westeurope"
    }
  }
}

module "kv" {
  source = "github.com/aztfmods/terraform-azure-kv?ref=v1.8.0"

  workload    = var.workload
  environment = var.environment

  vault = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

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
}
