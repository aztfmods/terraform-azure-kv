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

# module "network" {
#   source = "github.com/aztfmods/module-azurerm-vnet"

#   naming = {
#     company = local.naming.company
#     env     = local.naming.env
#     region  = local.naming.region
#   }

#   vnets = {
#     demo = {
#       cidr          = ["10.19.0.0/16"]
#       location      = module.global.groups.vault.location
#       resourcegroup = module.global.groups.vault.name
#       subnets = {
#         sn1 = { cidr = ["10.19.1.0/24"], endpoints = ["Microsoft.KeyVault"] }
#       }
#     }
#   }
#   depends_on = [module.global]
# }

module "kv" {
  source = "../../"

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

  vaults = {
    demo = {
      location          = module.global.groups.vault.location
      resourcegroup     = module.global.groups.vault.name
      sku               = "standard"
      retention_in_days = 7

      access_policy = {
        admins = {
          groups = [ "aad-group-1" ]
        }

        reader = {
          groups = [ "aad-group-2" ]
        }
      }

      # network_acls = {
      #   bypass         = "AzureServices"
      #   default_action = "Deny"
      #   ip_rules       = ["1.2.3.4"]
      #   subnet_ids     = [module.network.subnets["demo.sn1"].id]
      # }
    }
  }
  depends_on = [module.global]
}