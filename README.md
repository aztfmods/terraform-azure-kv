![example workflow](https://github.com/aztfmods/module-azurerm-kv/actions/workflows/validate.yml/badge.svg)
![example workflow](https://img.shields.io/github/v/release/aztfmods/module-azurerm-kv)

# Keyvault

Terraform module which creates keyvault resources on Azure.

The below features and integrations are made available:

- multiple keyvaults
- [keys](examples/keys/main.tf), [secrets](examples/secrets/main.tf), [certs](examples/certs/main.tf) support
- [terratest](https://terratest.gruntwork.io) is used to validate different integrations
- [diagnostic](examples/diagnostic-settings/main.tf) logs integration
- [certificate issuer](examples/cert-issuer/main.tf) support

The below examples shows the usage when consuming the module:

## Usage: simple

```hcl
module "kv" {
  source = "../../"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vaults = {
    demo = {
      location          = module.global.groups.demo.location
      resourcegroup     = module.global.groups.demo.name
      sku               = "standard"
      retention_in_days = 7
    }
  }
  depends_on = [module.global]
}
```

## Usage: keys

```hcl
module "kv" {
  source = "../../"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vaults = {
    demo = {
      location          = module.global.groups.demo.location
      resourcegroup     = module.global.groups.demo.name
      sku               = "standard"
      retention_in_days = 7

      keys = {
        demo = {
          key_type = "RSA"
          key_size = 2048
          key_opts = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
        }
      }
    }
  }
  depends_on = [module.global]
}
```

## Usage: secrets

```hcl
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

      secrets = {
        example1 = { length = 24 }
        example2 = { length = 24, special = false }
      }
    }
  }
  depends_on = [module.global]
}
```

## Usage: certs

```hcl
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
    }
  }
  depends_on = [module.global]
}
```

## Usage: issuers

```hcl
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
```

## Resources

| Name | Type |
| :-- | :-- |
| [azurerm_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_key_vault_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [key_vault_certificate_issuer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate_issuer) | resource |

## Data Sources

| Name | Type |
| :-- | :-- |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/1.39.0/docs/data-sources/resource_group) | datasource |
| [azurerm_client_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | datasource |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `vaults` | describes key vault related configuration | object | yes |
| `company` | contains the company name used, for naming convention  | string | yes |
| `region` | contains the shortname of the region, used for naming convention  | string | yes |
| `env` | contains shortname of the environment used for naming convention  | string | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `vaults` | contains all key vault config |
| `vault_keys` | contains all keyvault keys |
| `merged_ids` | contains all resource id's specified within the module |

## Authors

Module is maintained by [Dennis Kool](https://github.com/dkooll) with help from [these awesome contributors](https://github.com/aztfmods/module-azurerm-kv/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/aztfmods/module-azurerm-kv/blob/main/LICENSE) for full details.

## References

- [Keyvault Documentation - Microsoft docs](https://learn.microsoft.com/en-us/azure/key-vault/)
- [Keyvault Rest Api - Microsoft docs](https://learn.microsoft.com/en-us/rest/api/keyvault/)