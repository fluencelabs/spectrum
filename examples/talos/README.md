# talos

## Server customization

In talos machine is configured from a single configuration file in yaml format. Talos terraform module allows to specify overlays of the main configuration file maintained by cloudless labs [here](https://github.com/fluencelabs/spectrum/blob/main/terraform-modules/talos/templates/controlplane_patch.yml) with `config_paths` option.

You can configure server specific things like layout of disks or network configuration. Checkout [talos documentation](https://www.talos.dev/v1.9/reference/configuration/v1alpha1/config/) and see `config_path.yml` for an example of a `bond` interface configuration.

## Terraform state

terraform saves state of resources it manages to a state. By default state is local. It is highly recommended to configure remote [terraform state](https://developer.hashicorp.com/terraform/language/backend/s3).