# Changelog

## [0.1.8](https://github.com/fluencelabs/spectrum/compare/spectrum-v0.1.7...spectrum-v0.1.8) (2025-06-02)


### Bug Fixes

* **lightmare:** update to 0.4.5 ([#241](https://github.com/fluencelabs/spectrum/issues/241)) ([6ebe98e](https://github.com/fluencelabs/spectrum/commit/6ebe98e5021c1c8b9c3e15d3dfc1b062ad5fcf36))

## [0.1.7](https://github.com/fluencelabs/spectrum/compare/spectrum-v0.1.6...spectrum-v0.1.7) (2025-06-02)


### Bug Fixes

* Add annotation to force restart ligthmare ([#238](https://github.com/fluencelabs/spectrum/issues/238)) ([7a537f7](https://github.com/fluencelabs/spectrum/commit/7a537f76fb45ce9d64df85775fdfaab98d6eeaa6))

## [0.1.6](https://github.com/fluencelabs/spectrum/compare/spectrum-v0.1.5...spectrum-v0.1.6) (2025-05-30)


### Features

* adding lightmare grafana dashboard ([#230](https://github.com/fluencelabs/spectrum/issues/230)) ([1bb5277](https://github.com/fluencelabs/spectrum/commit/1bb527710bab2f3998376bb1f7c7deead67f4dff))


### Bug Fixes

* update lightmare to 0.4.4 ([#237](https://github.com/fluencelabs/spectrum/issues/237)) ([b823cf6](https://github.com/fluencelabs/spectrum/commit/b823cf6aeee33b85029174de348e1cc8a94b28a2))

## [0.1.5](https://github.com/fluencelabs/spectrum/compare/spectrum-v0.1.4...spectrum-v0.1.5) (2025-05-20)


### Bug Fixes

* update lightmare to 0.4.3 ([#226](https://github.com/fluencelabs/spectrum/issues/226)) ([852e80a](https://github.com/fluencelabs/spectrum/commit/852e80a8d739dc6ae2083f203bd8323fe067b6fd))

## [0.1.4](https://github.com/fluencelabs/spectrum/compare/spectrum-v0.1.3...spectrum-v0.1.4) (2025-05-14)


### Bug Fixes

* update lightmare to 0.4.2 ([#224](https://github.com/fluencelabs/spectrum/issues/224)) ([b2e69f4](https://github.com/fluencelabs/spectrum/commit/b2e69f403540b4b7995d0c6264dfc86c46cbcf43))
* update ligthmare to 0.4.2 ([b2e69f4](https://github.com/fluencelabs/spectrum/commit/b2e69f403540b4b7995d0c6264dfc86c46cbcf43))

## [0.1.3](https://github.com/fluencelabs/spectrum/compare/spectrum-v0.1.2...spectrum-v0.1.3) (2025-04-30)


### Bug Fixes

* update lightmare ([#210](https://github.com/fluencelabs/spectrum/issues/210)) ([9818fea](https://github.com/fluencelabs/spectrum/commit/9818fead4be29ef0be957bf732c79c866165c38e))

## [0.1.2](https://github.com/fluencelabs/spectrum/compare/spectrum-v0.1.1...spectrum-v0.1.2) (2025-04-30)


### Bug Fixes

* revert ccp ([#205](https://github.com/fluencelabs/spectrum/issues/205)) ([22c657f](https://github.com/fluencelabs/spectrum/commit/22c657f781f596c8f0a73399ed5bebf4ab59b45d))

## [0.1.1](https://github.com/fluencelabs/spectrum/compare/spectrum-v0.1.0...spectrum-v0.1.1) (2025-04-24)


### Bug Fixes

* Update lightmare ([#201](https://github.com/fluencelabs/spectrum/issues/201)) ([c8ac1de](https://github.com/fluencelabs/spectrum/commit/c8ac1de54f7d975ec2bfac733d7c0da60b663ef1))

## 0.1.0 (2025-03-20)


### Features

* Add terraform modules ([#16](https://github.com/fluencelabs/spectrum/issues/16)) ([71a2bf5](https://github.com/fluencelabs/spectrum/commit/71a2bf52ab0f27fb818220e1b79d1759c5ef08ee))
* flux alerts + optional alerting to Slack ([#169](https://github.com/fluencelabs/spectrum/issues/169)) ([4e51a8a](https://github.com/fluencelabs/spectrum/commit/4e51a8a1a496dfefa3e47ff1b0c133bad13c2f35))
* k3s tf module ([294e7cd](https://github.com/fluencelabs/spectrum/commit/294e7cda89d7e23a7ef4cfc0a3c87915ea499773))
* Setup system metrics collection (host, k8s, cilium, kubevirt) ([#95](https://github.com/fluencelabs/spectrum/issues/95)) ([d23d5b8](https://github.com/fluencelabs/spectrum/commit/d23d5b8c6d505462fc54cdb3c5b7ec6f0b226a74))
* update ccp-cu-worker to 0.16.1 ([#109](https://github.com/fluencelabs/spectrum/issues/109)) ([9c5f7e5](https://github.com/fluencelabs/spectrum/commit/9c5f7e525b7aa44c0993f04e72808637e583ef75))
* Update talos to version 1.9.1 and add selinux workaround ([#90](https://github.com/fluencelabs/spectrum/issues/90)) ([e56a220](https://github.com/fluencelabs/spectrum/commit/e56a2202b94384c3b084e4674b70b597eaad422d))


### Bug Fixes

* bind kube-scheduler and kube-controller on 0.0.0.0 to collect metrics ([e9f4203](https://github.com/fluencelabs/spectrum/commit/e9f4203c33c1581c845f076f835f6a291a45540c))
* Bump talos version to 1.9.2 ([#98](https://github.com/fluencelabs/spectrum/issues/98)) ([92e8605](https://github.com/fluencelabs/spectrum/commit/92e86052775b55de00986629f781e09285b9dae2))
* dependency on serviceMonitor when monitoring component is not enabled ([e9f4203](https://github.com/fluencelabs/spectrum/commit/e9f4203c33c1581c845f076f835f6a291a45540c))
* Disable creation of service monitor for now ([#102](https://github.com/fluencelabs/spectrum/issues/102)) ([fa57329](https://github.com/fluencelabs/spectrum/commit/fa5732905470e5af60b888538c0facc44a48968d))
* Spectrum priority class tune ([#150](https://github.com/fluencelabs/spectrum/issues/150)) ([d81ee3f](https://github.com/fluencelabs/spectrum/commit/d81ee3f6a14a8b45fcd5633ff220ce6556de1c5c))
* Test commit to check release pipeline ([#188](https://github.com/fluencelabs/spectrum/issues/188)) ([9b61350](https://github.com/fluencelabs/spectrum/commit/9b613501fa1fb25159ef5658a1a3315cc1e8479f))
