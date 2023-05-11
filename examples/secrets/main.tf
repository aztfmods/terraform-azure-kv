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
  source = "github.com/aztfmods/module-azurerm-kv"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vault = {
    location      = module.global.groups.demo.location
    resourcegroup = module.global.groups.demo.name

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
  depends_on = [module.global]
}
