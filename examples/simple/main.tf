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

# module "network" {
#   source = "github.com/aztfmods/module-azurerm-vnet"

# company = module.global.company
# env     = module.global.env
# region  = module.global.region

#   vnets = {
#     demo = {
#       cidr          = ["10.19.0.0/16"]
#       location      = module.global.groups.demo.location
#       resourcegroup = module.global.groups.demo.name
#       subnets = {
#         sn1 = { cidr = ["10.19.1.0/24"], endpoints = ["Microsoft.KeyVault"] }
#       }
#     }
#   }
#   depends_on = [module.global]
# }

module "kv" {
  source = "../../"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vault = {
    location      = module.global.groups.demo.location
    resourcegroup = module.global.groups.demo.name

    contacts = {
      admin = {
        email = "dummy@cloudnation.nl"
      }
    }
  }
  depends_on = [module.global]
}