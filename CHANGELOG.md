# Changelog

## [1.9.0](https://github.com/aztfmods/terraform-azure-kv/compare/v1.8.0...v1.9.0) (2023-07-03)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#57](https://github.com/aztfmods/terraform-azure-kv/issues/57)) ([ad806d7](https://github.com/aztfmods/terraform-azure-kv/commit/ad806d785c453128e689b45a1a9c161d400c6878))

## [1.8.0](https://github.com/aztfmods/module-azurerm-kv/compare/v1.7.0...v1.8.0) (2023-05-11)


### Features

* refactor tests to make use of shared packages ([#52](https://github.com/aztfmods/module-azurerm-kv/issues/52)) ([10b5621](https://github.com/aztfmods/module-azurerm-kv/commit/10b5621daff490d6ae0115468da5895abfc00e2d))
* update documentation ([#50](https://github.com/aztfmods/module-azurerm-kv/issues/50)) ([e42a048](https://github.com/aztfmods/module-azurerm-kv/commit/e42a048b977b5804111beea22a716b8f017b650a))

## [1.7.0](https://github.com/aztfmods/module-azurerm-kv/compare/v1.6.0...v1.7.0) (2023-03-22)


### Features

* add tls private key support ([#45](https://github.com/aztfmods/module-azurerm-kv/issues/45)) ([27ff483](https://github.com/aztfmods/module-azurerm-kv/commit/27ff483528fa78f289a5f69487e18f57f1fa98f5))

## [1.6.0](https://github.com/aztfmods/module-azurerm-kv/compare/v1.5.0...v1.6.0) (2023-03-22)


### Features

* add rotation_policy support for keys ([#43](https://github.com/aztfmods/module-azurerm-kv/issues/43)) ([4e20a50](https://github.com/aztfmods/module-azurerm-kv/commit/4e20a50da3a3ed512b50bb9973e3f9e4a8a56784))

## [1.5.0](https://github.com/aztfmods/module-azurerm-kv/compare/v1.4.0...v1.5.0) (2023-03-08)


### Features

* simplify structure and added lifecycle ignore on the inline contact block ([#39](https://github.com/aztfmods/module-azurerm-kv/issues/39)) ([d7978fc](https://github.com/aztfmods/module-azurerm-kv/commit/d7978fcc0b4a8c8780690f5e50d0d90cbf2f24df))

## [1.4.0](https://github.com/aztfmods/module-azurerm-kv/compare/v1.3.0...v1.4.0) (2022-12-22)


### Features

* add azurerm_key_vault_certificate_contacts support ([#32](https://github.com/aztfmods/module-azurerm-kv/issues/32)) ([b927ab6](https://github.com/aztfmods/module-azurerm-kv/commit/b927ab6be15fcab279540d8fa9cb391ef62d8432))
* add azurerm_key_vault_certificate_issuer support ([#31](https://github.com/aztfmods/module-azurerm-kv/issues/31)) ([827d022](https://github.com/aztfmods/module-azurerm-kv/commit/827d022b23712a91074c5320459f5aaed9e60205))
* add diagnostics integration ([#29](https://github.com/aztfmods/module-azurerm-kv/issues/29)) ([d98ea92](https://github.com/aztfmods/module-azurerm-kv/commit/d98ea926f86ab27cbe3fdc1ff5a40afbff951a94))

## [1.3.0](https://github.com/aztfmods/module-azurerm-kv/compare/v1.2.0...v1.3.0) (2022-12-06)


### Features

* small refactor naming convention ([#23](https://github.com/aztfmods/module-azurerm-kv/issues/23)) ([fa1ca1f](https://github.com/aztfmods/module-azurerm-kv/commit/fa1ca1fbb2f493a1c9efd030ec8f4d0b443d9287))

## [1.2.0](https://github.com/aztfmods/module-azurerm-kv/compare/v1.1.0...v1.2.0) (2022-12-05)


### Features

* add azurerm_key_vault_certificate support ([#20](https://github.com/aztfmods/module-azurerm-kv/issues/20)) ([cff403c](https://github.com/aztfmods/module-azurerm-kv/commit/cff403c56bac416bf44808cf176df76f34885f1d))

## [1.1.0](https://github.com/aztfmods/module-azurerm-kv/compare/v1.0.0...v1.1.0) (2022-12-05)


### Features

* add azurerm_key_vault_secret support ([#18](https://github.com/aztfmods/module-azurerm-kv/issues/18)) ([53105a3](https://github.com/aztfmods/module-azurerm-kv/commit/53105a30706a6da025266c9d948b94c3e7673d0a))

## 1.0.0 (2022-12-02)


### Features

* add initial documentation ([#14](https://github.com/aztfmods/module-azurerm-kv/issues/14)) ([f420f55](https://github.com/aztfmods/module-azurerm-kv/commit/f420f55f59847e9fd9459cec72c88d9ecfa01f9c))
* add initial module ([#1](https://github.com/aztfmods/module-azurerm-kv/issues/1)) ([d1b2d10](https://github.com/aztfmods/module-azurerm-kv/commit/d1b2d108b6618f8b0c639ee723fb6462efe29272))
* add initial probot config ([#4](https://github.com/aztfmods/module-azurerm-kv/issues/4)) ([f1fe88e](https://github.com/aztfmods/module-azurerm-kv/commit/f1fe88e8a432ea6318e465cfb1c230f786a5112c))
* add keyvault keys support ([#16](https://github.com/aztfmods/module-azurerm-kv/issues/16)) ([c51e737](https://github.com/aztfmods/module-azurerm-kv/commit/c51e73712c941316dc382875b34aef2c64433496))
* add validation workflow ([#11](https://github.com/aztfmods/module-azurerm-kv/issues/11)) ([ce828bb](https://github.com/aztfmods/module-azurerm-kv/commit/ce828bb180014462ba8d1a96f726e16d5a3b5770))


### Bug Fixes

* change dynamic block network_acls to be optional ([#3](https://github.com/aztfmods/module-azurerm-kv/issues/3)) ([47b67a7](https://github.com/aztfmods/module-azurerm-kv/commit/47b67a740e74c36eac3df95cffd291814a6feff4))
