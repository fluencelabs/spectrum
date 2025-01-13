module "spectrum" {
  depends_on = [module.talos]
  source     = "git::https://github.com/fluencelabs/spectrum.git//terraform-modules/spectrum?ref=terraform-module-spectrum-v0.1.0" # x-release-please-version
  network    = "main"
  cluster    = "default"
}
