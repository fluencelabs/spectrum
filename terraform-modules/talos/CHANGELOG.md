# Changelog

## [0.2.2](https://github.com/fluencelabs/spectrum/compare/terraform-module-talos-v0.2.1...terraform-module-talos-v0.2.2) (2025-05-09)


### Features

* Update talos provider version to 0.8 (1.10.x) ([#214](https://github.com/fluencelabs/spectrum/issues/214)) ([1625703](https://github.com/fluencelabs/spectrum/commit/162570395e819756c1e9c8d3620c69e867123e05))


### Bug Fixes

* bind kube-scheduler and kube-controller on 0.0.0.0 to collect metrics ([e9f4203](https://github.com/fluencelabs/spectrum/commit/e9f4203c33c1581c845f076f835f6a291a45540c))
* dependency on serviceMonitor when monitoring component is not enabled ([e9f4203](https://github.com/fluencelabs/spectrum/commit/e9f4203c33c1581c845f076f835f6a291a45540c))

## [0.2.1](https://github.com/fluencelabs/spectrum/compare/terraform-module-talos-v0.2.0...terraform-module-talos-v0.2.1) (2025-01-23)


### Bug Fixes

* Bump talos version to 1.9.2 ([#98](https://github.com/fluencelabs/spectrum/issues/98)) ([92e8605](https://github.com/fluencelabs/spectrum/commit/92e86052775b55de00986629f781e09285b9dae2))

## [0.2.0](https://github.com/fluencelabs/spectrum/compare/terraform-module-talos-v0.1.0...terraform-module-talos-v0.2.0) (2025-01-15)


### ⚠ BREAKING CHANGES

* talos multinode initial support ([#72](https://github.com/fluencelabs/spectrum/issues/72))

### Features

* talos multinode initial support ([#72](https://github.com/fluencelabs/spectrum/issues/72)) ([f818568](https://github.com/fluencelabs/spectrum/commit/f818568f1e4cadf7efc486897c0b488d5ecac4f6))
* Update talos to version 1.9.1 and add selinux workaround ([#90](https://github.com/fluencelabs/spectrum/issues/90)) ([e56a220](https://github.com/fluencelabs/spectrum/commit/e56a2202b94384c3b084e4674b70b597eaad422d))


### Bug Fixes

* kubeconfig creation waits for bootstrap ([#94](https://github.com/fluencelabs/spectrum/issues/94)) ([a948c5e](https://github.com/fluencelabs/spectrum/commit/a948c5eed6077a67aa7b660c5ca36624c03094d3))

## 0.1.0 (2025-01-13)


### Features

* Add terraform modules ([#16](https://github.com/fluencelabs/spectrum/issues/16)) ([71a2bf5](https://github.com/fluencelabs/spectrum/commit/71a2bf52ab0f27fb818220e1b79d1759c5ef08ee))
