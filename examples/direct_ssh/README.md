# SCCA compliant Azure Storage Account Overlay with all storage account features

This example is to create a storage account with containers, SMB file shares, tables, queues, lifecycle management, private endpoints and other additional features.

## SCCA Compliance

This example is SCCA Compliant. For more information, please refer to the [SCCA Compliance]("https://www.cisa.gov/secure-cloud-computing-architecture").

## Required Terraform Code
```hcl
# Required resource in dependencies.tf
resource "azurerm_network_security_group" "jump-nsg" {
    name                = "vm-nsg"
    location            = var.location
    resource_group_name = module.mod_linux_vm.linux_vm_resource_group_name

    security_rule {
        name                       = "allow-ssh"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

# Required line item in main.tf
module "mod_linux_vm" {
  admin_ssh_key_data = "./testkeys/public.pem"
  attach_existing_network_security_group = true
  existing_network_security_group_id = azurerm_network_security_group.jump-nsg.id
}
```

## Terraform Usage

To run this example you need to execute following Terraform commands

```hcl
terraform init
terraform plan
terraform apply
```

Run `terraform destroy` when you don't need these resources.

## RSA & SSH

This use case uses RSA test keys for direct ssh. They have been stored in the testkeys directory. Do not re-use these keys ina production system as the private key is exposed on the internet.

For direct ssh testing use the following command

```bash
ssh -i ./testkeys/key.pem <admin_username>@<org_name>-<location>-<workload_name>-<environment>-vm.eastus.cloudapp.azure.com
```