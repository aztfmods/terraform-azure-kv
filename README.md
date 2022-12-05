![example workflow](https://github.com/aztfmods/module-azurerm-kv/actions/workflows/validate.yml/badge.svg)

# Keyvault

Terraform module which creates keyvault resources on Azure.

The below features and integrations are made available:

- multiple keyvaults
- [keys](examples/keys/main.tf) and [secrets](examples/secrets/main.tf) support
- [terratest](https://terratest.gruntwork.io) is used to validate different integrations

The below examples shows the usage when consuming the module:

## Usage: simple

```hcl
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
    }
  }
  depends_on = [module.global]
}
```

## Usage: keys

```hcl
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

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

  vaults = {
    demo = {
      location      = module.global.groups.vault.location
      resourcegroup = module.global.groups.vault.name
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

## Resources

| Name | Type |
| :-- | :-- |
| [azurerm_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_key_vault_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |

## Data Sources

| Name | Type |
| :-- | :-- |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/1.39.0/docs/data-sources/resource_group) | datasource |
| [azurerm_client_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | datasource |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `vaults` | describes key vault related configuration | object | yes |
| `naming` | contains naming convention | string | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `vaults` | contains all key vault config |
| `vault_keys` | contains all keyvault keys |

## Authors

Module is maintained by [Dennis Kool](https://github.com/dkooll) with help from [these awesome contributors](https://github.com/aztfmods/module-azurerm-kv/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/aztfmods/module-azurerm-kv/blob/main/LICENSE) for full details.