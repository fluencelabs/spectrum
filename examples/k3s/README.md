# Kubernetes cluster based on k3s

This example deploys *k3s based* Kubernetes cluster on a specific host.

### Requirements
- installed [**Terraform**](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) on your laptop
- installed [**autok3s**](https://github.com/cnrancher/autok3s?tab=readme-ov-file#quick-start-tldr) on your laptop
- target server accessible via `ssh`

### Instruction
- Copy files in this directory to your Fluence related *provider* directory
- Update values with your own in `config.tf` file
```
locals {
server_name  =  "example"
server_ip_address  =  "1.1.1.1.1"
ssh_key  =  "~/.ssh/key"
ssh_user  =  "root"
ssh_port  =  "22"
}
```
- deploy using `terraform`
```
terraform init
terraform apply
```
- you can check your freshly installed cluster in [**autok3s UI**](https://github.com/cnrancher/autok3s?tab=readme-ov-file#quick-start-tldr) 
