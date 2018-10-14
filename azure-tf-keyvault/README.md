# Terraform: Azure VMs

## Pre-Req

## Deploy

Linux

```sh
export TF_VAR_access_key = "***"
export TF_VAR_subscription_id = "***"
export TF_VAR_tenant_id = "***"
export TF_VAR_client_id = "***"
export TF_VAR_client_secret = "****"
```

Windows

```powershell
$Env:TF_VAR_access_key = "***"
$Env:TF_VAR_subscription_id = "***"
$Env:TF_VAR_tenant_id = "***"
$Env:TF_VAR_client_id = "***"
$Env:TF_VAR_client_secret = "****"
```

```batch
terraform init -backend-config="dev/backend.tfvars"
terraform validate -var-file="dev/env.tfvars" -var-file="global_vars/global.tfvars"
terraform plan -var-file="dev/env.tfvars" -var-file="global_vars/global.tfvars"
terraform apply -var-file="dev/env.tfvars" -var-file="global_vars/global.tfvars"
terraform destroy -var-file="dev/env.tfvars" -var-file="global_vars/global.tfvars"
```

## To Look at

- **Terraform Data External**
    1. Azure Key Vault [Example](https://magentys.io/using-azure-key-vault/)
    1. GO using SSH Private Key
    1. git crypet....

## Ref

- Holy Shitballs how complex is this [Here](https://github.com/Azure/terraform-azurerm-compute/blob/master/main.tf) (So much to unpack here not sure your occasional user will grok it.)
- [Getting Srarted](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-create-complete-vm?toc=%2Fen-us%2Fazure%2Fterraform%2Ftoc.json&bc=%2Fen-us%2Fazure%2Fbread%2Ftoc.json)
- [Multiple Environments](http://www.mikaelkrief.com/provision-multiple-azure-environments-terraform/)
- [Terraform Backend Details](http://www.mikaelkrief.com/terraform-remote-backend-azure/)
