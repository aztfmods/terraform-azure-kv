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

  vault = {
    location      = module.global.groups.demo.location
    resourcegroup = module.global.groups.demo.name

    keys = {
      demo = {
        key_type = "RSA"
        key_size = 2048
        key_opts = [
          "decrypt", "encrypt", "sign",
          "unwrapKey", "verify", "wrapKey"
        ]
        rotation_policy = {
          expire_after         = "P90D"
          notify_before_expiry = "P30D"
          automatic            = {
            time_after_creation = "P83D"
            time_before_expiry  = "P30D"
          }
        }
      }
    }

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

    issuers = {
      digicert = {
        org_id     = "12345"
        provider   = "DigiCert"
        account_id = "12345"
        password   = "12345"
      }
    }

    certs = {
      example = {
        issuer = "Self", subject = "CN=app1.demo.org", validity_in_months = 12, exportable = true
        key_usage = [
          "cRLSign", "dataEncipherment",
          "digitalSignature", "keyAgreement",
          "keyCertSign", "keyEncipherment"
        ]
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