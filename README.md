# Azure Linux Virtual Machines Overlay Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurenoops/overlays-linux-virtualmachine/azurerm/)

This Overlay terraform module can create a Linux Virtual Machine and manage related parameters (public ip, network interface. proximity placement group, availability set, etc.) to be used in a [SCCA compliant Network](https://registry.terraform.io/modules/azurenoops/overlays-hubspoke/azurerm/latest).

## SCCA Compliance

This module can be SCCA compliant and can be used in a SCCA compliant Network. Enable SCCA compliant network rules to make it SCCA compliant.

For more information, please read the [SCCA documentation]("https://www.cisa.gov/secure-cloud-computing-architecture").

## Contributing

If you want to contribute to this repository, feel free to to contribute to our Terraform module.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Resources Used

* [Azure Virtual Machine](https://www.terraform.io/docs/providers/azurerm/r/linux_virtual_machine.html)
* [Azure Virtual Machine Data Disk](https://www.terraform.io/docs/providers/azurerm/r/linux_virtual_machine_data_disk_attachment.html)
* [Azure Virtual Machine Extension](https://www.terraform.io/docs/providers/azurerm/r/virtual_machine_extension.html)
* [Azure Resource Locks](https://www.terraform.io/docs/providers/azurerm/r/management_lock.html)

## Overlay Module Usage for basic linux virtual machine

```terraform
# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

#---------------------------------------------------------
# Azure Region Lookup
#----------------------------------------------------------
module "mod_azure_region_lookup" {
  source  = "azurenoops/overlays-azregions-lookup/azurerm"
  version = "~> 1.0.0"

  azure_region = "eastus"
}


module "mod_linux_vm" {
  depends_on = [
    azurerm_virtual_network.vnet
  ]
  source  = ""azurenoops/overlays-linux-virtualmachine/azurerm"
  version = "x.x.x"

  # Resource Group, location, VNet and Subnet details
  create_vm_resource_group = true
  location                 = var.location
  environment              = var.environment
  org_name                 = var.org_name
  workload_name            = "jumpbox"
  vm_subnet_id             = azurerm_subnet.example.id
  virtual_machine_name     = "linux"

  # This module support multiple Pre-Defined Linux and Windows Distributions.
  # Check the README.md file for more pre-defined images for Ubuntu, Centos, RedHat.
  # Please make sure to use gen2 images supported VM sizes if you use gen2 distributions
  # Specify `disable_password_authentication = false` to create random admin password
  # Specify a valid password with `admin_password` argument to use your own password 
  # To generate SSH key pair, specify `generate_admin_ssh_key = true`
  # To use existing key pair, specify `admin_ssh_key_data` to a valid SSH public key path.
  # Specify instance_count = 1 to create a single instance, or specify a higher number to create multiple instances  
  linux_distribution_name         = "ubuntu1804"
  virtual_machine_size            = var.virtual_machine_size
  admin_username                  = var.admin_username
  admin_password                  = "P@ssw0rd1234"
  aad_ssh_login_enabled           = false
  generate_admin_ssh_key          = false
  instances_count                 = 1

  # Proxymity placement group, Availability Set and adding Public IP to VM's are optional.
  # remove these argument from module if you dont want to use it.  
  enable_proximity_placement_group = false
  enable_vm_availability_set       = true
  enable_public_ip_address         = true

  # Network Seurity group port allow definitions for each Virtual Machine
  # NSG association to be added automatically for all network interfaces.
  # Remove this NSG rules block, if `existing_network_security_group_id` is specified
  attach_existing_network_security_group = false
  # existing_network_security_group_id = var.network_security_group_id

  # Boot diagnostics to troubleshoot virtual machines, by default uses managed 
  # To use custom storage account, specify `storage_account_name` with a valid name
  # Passing a `null` value will utilize a Managed Storage Account to store Boot Diagnostics
  enable_boot_diagnostics = false
  # storage_account_name    = var.storage_account_name

  # Attach a managed data disk to a Windows/Linux VM's. Possible Storage account type are: 
  # `Standard_LRS`, `StandardSSD_ZRS`, `Premium_LRS`, `Premium_ZRS`, `StandardSSD_LRS`
  # or `UltraSSD_LRS` (UltraSSD_LRS only available in a region that support availability zones)
  # Initialize a new data disk - you need to connect to the VM and run diskmanagemnet or fdisk
  data_disks = {
    disk1 = {
      name                 = "disk1"
      disk_size_gb         = 100
      lun                  = 0
      storage_account_type = "StandardSSD_LRS"
    }
    disk2 = {
      name                 = "disk2"
      disk_size_gb         = 100
      lun                  = 1
      storage_account_type = "StandardSSD_LRS"
    }
  }

  # (Optional) To enable Azure Monitoring and install log analytics agents
  # (Optional) Specify `storage_account_name` to save monitoring logs to storage.   
  # log_analytics_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  # Deploy log analytics agents to virtual machine. 
  # Log analytics workspace primary shared key required.
  deploy_log_analytics_agent = false
  # log_analytics_workspace_primary_shared_key = azurerm_log_analytics_workspace.log_analytics_workspace.primary_shared_key

  // Tags
  add_tags = merge(var.tags, {
    example = "basic-linux-vm"
  })
}

```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azurenoopsutils"></a> [azurenoopsutils](#requirement\_azurenoopsutils) | ~> 1.0.4 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurenoopsutils"></a> [azurenoopsutils](#provider\_azurenoopsutils) | ~> 1.0.4 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.22 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_availability_set.aset](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set) | resource |
| [azurerm_backup_protected_vm.backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_protected_vm) | resource |
| [azurerm_linux_virtual_machine.linux_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.data_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_application_gateway_backend_address_pool_association.appgw_pool_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_gateway_backend_address_pool_association) | resource |
| [azurerm_network_interface_backend_address_pool_association.lb_pool_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_security_group_association.nsgassoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_proximity_placement_group.appgrp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/proximity_placement_group) | resource |
| [azurerm_public_ip.pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.rbac_admin_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rbac_user_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_virtual_machine_data_disk_attachment.data_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.aad_ssh_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.oms_agent_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [tls_private_key.rsa](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurenoopsutils_resource_name.disk](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.nic](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.pub_ip](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.vm](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurerm_storage_account.storeacc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_subnet.snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_ssh_login_enabled"></a> [aad\_ssh\_login\_enabled](#input\_aad\_ssh\_login\_enabled) | Enable SSH logins with Azure Active Directory | `bool` | `false` | no |
| <a name="input_aad_ssh_login_extension_version"></a> [aad\_ssh\_login\_extension\_version](#input\_aad\_ssh\_login\_extension\_version) | VM Extension version for Azure Active Directory SSH Login extension | `string` | `"1.0"` | no |
| <a name="input_aad_ssh_login_user_objects_ids"></a> [aad\_ssh\_login\_user\_objects\_ids](#input\_aad\_ssh\_login\_user\_objects\_ids) | Azure Active Directory objects IDs allowed to connect as standard user on the VM. | `list(string)` | `[]` | no |
| <a name="input_add_tags"></a> [add\_tags](#input\_add\_tags) | Extra tags to set on each created resource. | `map(string)` | `{}` | no |
| <a name="input_additional_unattend_content"></a> [additional\_unattend\_content](#input\_additional\_unattend\_content) | The XML formatted content that is added to the unattend.xml file for the specified path and component. | `any` | `null` | no |
| <a name="input_additional_unattend_content_setting"></a> [additional\_unattend\_content\_setting](#input\_additional\_unattend\_content\_setting) | The name of the setting to which the content applies. Possible values are `AutoLogon` and `FirstLogonCommands` | `any` | `null` | no |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | The Password which should be used for the local-administrator on this Virtual Machine | `any` | `null` | no |
| <a name="input_admin_ssh_key_data"></a> [admin\_ssh\_key\_data](#input\_admin\_ssh\_key\_data) | specify the path to the existing SSH key to authenticate Linux virtual machine | `any` | `null` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | The username of the local administrator used for the Virtual Machine. | `string` | `"azureadmin"` | no |
| <a name="input_application_gateway_backend_pool_id"></a> [application\_gateway\_backend\_pool\_id](#input\_application\_gateway\_backend\_pool\_id) | Id of the Application Gateway Backend Pool to attach the VM. | `string` | `null` | no |
| <a name="input_attach_application_gateway"></a> [attach\_application\_gateway](#input\_attach\_application\_gateway) | True to attach this VM to an Application Gateway | `bool` | `false` | no |
| <a name="input_attach_load_balancer"></a> [attach\_load\_balancer](#input\_attach\_load\_balancer) | True to attach this VM to a Load Balancer | `bool` | `false` | no |
| <a name="input_backup_policy_id"></a> [backup\_policy\_id](#input\_backup\_policy\_id) | Backup policy ID from the Recovery Vault to attach the Virtual Machine to (value to `null` to disable backup) | `string` | `null` | no |
| <a name="input_create_vm_resource_group"></a> [create\_vm\_resource\_group](#input\_create\_vm\_resource\_group) | Should a resource group be created for the VM? Defaults to false | `bool` | `false` | no |
| <a name="input_custom_computer_name"></a> [custom\_computer\_name](#input\_custom\_computer\_name) | Custom name for the Virtual Machine Hostname. `vm_name` if not set. | `string` | `""` | no |
| <a name="input_custom_data"></a> [custom\_data](#input\_custom\_data) | Base64 encoded file of a bash script that gets run once by cloud-init upon VM creation | `any` | `null` | no |
| <a name="input_custom_dcr_name"></a> [custom\_dcr\_name](#input\_custom\_dcr\_name) | Custom name for Data collection rule association | `string` | `null` | no |
| <a name="input_custom_image"></a> [custom\_image](#input\_custom\_image) | Provide the custom image to this module if the default variants are not sufficient | <pre>map(object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  }))</pre> | `null` | no |
| <a name="input_custom_ipconfig_name"></a> [custom\_ipconfig\_name](#input\_custom\_ipconfig\_name) | Custom name for the IP config of the NIC. Generated if not set. | `string` | `null` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | Custom name for the Virtual Machine. Generated if not set. | `string` | `""` | no |
| <a name="input_custom_nic_name"></a> [custom\_nic\_name](#input\_custom\_nic\_name) | Custom name for the NIC interface. Generated if not set. | `string` | `null` | no |
| <a name="input_custom_public_ip_name"></a> [custom\_public\_ip\_name](#input\_custom\_public\_ip\_name) | Custom name for public IP. Generated if not set. | `string` | `null` | no |
| <a name="input_data_disks"></a> [data\_disks](#input\_data\_disks) | A list of Data Disks which should be attached to the Virtual Machine. Each Data Disk can be configured with the following properties: | <pre>map(object({<br>    name                 = optional(string)<br>    create_option        = optional(string, "Empty")<br>    disk_size_gb         = number<br>    lun                  = optional(number)<br>    caching              = optional(string, "ReadWrite")<br>    storage_account_type = optional(string, "StandardSSD_ZRS")<br>    source_resource_id   = optional(string)<br>    add_tags           = optional(map(string), {})<br>  }))</pre> | `{}` | no |
| <a name="input_dedicated_host_id"></a> [dedicated\_host\_id](#input\_dedicated\_host\_id) | The ID of a Dedicated Host where this machine should be run on. | `any` | `null` | no |
| <a name="input_default_tags_enabled"></a> [default\_tags\_enabled](#input\_default\_tags\_enabled) | Option to enable or disable default tags. | `bool` | `true` | no |
| <a name="input_deploy_log_analytics_agent"></a> [deploy\_log\_analytics\_agent](#input\_deploy\_log\_analytics\_agent) | Install log analytics agent to windows or linux VM | `bool` | `false` | no |
| <a name="input_disable_password_authentication"></a> [disable\_password\_authentication](#input\_disable\_password\_authentication) | Should Password Authentication be disabled on this Virtual Machine? Defaults to true. | `bool` | `true` | no |
| <a name="input_disk_encryption_set_id"></a> [disk\_encryption\_set\_id](#input\_disk\_encryption\_set\_id) | The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk. The Disk Encryption Set must have the `Reader` Role Assignment scoped on the Key Vault - in addition to an Access Policy to the Key Vault | `any` | `null` | no |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from. | `any` | `null` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | List of dns servers to use for network interface | `list` | `[]` | no |
| <a name="input_domain_name_label"></a> [domain\_name\_label](#input\_domain\_name\_label) | Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system. | `any` | `null` | no |
| <a name="input_enable_accelerated_networking"></a> [enable\_accelerated\_networking](#input\_enable\_accelerated\_networking) | Should Accelerated Networking be enabled? Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_automatic_updates"></a> [enable\_automatic\_updates](#input\_enable\_automatic\_updates) | Specifies if Automatic Updates are Enabled for the Windows Virtual Machine. | `bool` | `false` | no |
| <a name="input_enable_boot_diagnostics"></a> [enable\_boot\_diagnostics](#input\_enable\_boot\_diagnostics) | Should the boot diagnostics enabled? | `bool` | `false` | no |
| <a name="input_enable_encryption_at_host"></a> [enable\_encryption\_at\_host](#input\_enable\_encryption\_at\_host) | Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host? | `bool` | `false` | no |
| <a name="input_enable_ip_forwarding"></a> [enable\_ip\_forwarding](#input\_enable\_ip\_forwarding) | Should IP Forwarding be enabled? Defaults to false | `bool` | `false` | no |
| <a name="input_enable_os_disk_write_accelerator"></a> [enable\_os\_disk\_write\_accelerator](#input\_enable\_os\_disk\_write\_accelerator) | Should Write Accelerator be Enabled for this OS Disk? This requires that the `storage_account_type` is set to `Premium_LRS` and that `caching` is set to `None`. | `bool` | `false` | no |
| <a name="input_enable_proximity_placement_group"></a> [enable\_proximity\_placement\_group](#input\_enable\_proximity\_placement\_group) | Manages a proximity placement group for virtual machines, virtual machine scale sets and availability sets. | `bool` | `false` | no |
| <a name="input_enable_public_ip_address"></a> [enable\_public\_ip\_address](#input\_enable\_public\_ip\_address) | Reference to a Public IP Address to associate with the NIC | `any` | `null` | no |
| <a name="input_enable_ultra_ssd_data_disk_storage_support"></a> [enable\_ultra\_ssd\_data\_disk\_storage\_support](#input\_enable\_ultra\_ssd\_data\_disk\_storage\_support) | Should the capacity to enable Data Disks of the UltraSSD\_LRS storage account type be supported on this Virtual Machine | `bool` | `false` | no |
| <a name="input_enable_vm_availability_set"></a> [enable\_vm\_availability\_set](#input\_enable\_vm\_availability\_set) | Manages an Availability Set for Virtual Machines. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the workload's environnement | `string` | n/a | yes |
| <a name="input_existing_network_security_group_id"></a> [existing\_network\_security\_group\_id](#input\_existing\_network\_security\_group\_id) | The resource id of existing network security group | `any` | `null` | no |
| <a name="input_extensions_add_tags"></a> [extensions\_add\_tags](#input\_extensions\_add\_tags) | Extra tags to set on the VM extensions. | `map(string)` | `{}` | no |
| <a name="input_generate_admin_ssh_key"></a> [generate\_admin\_ssh\_key](#input\_generate\_admin\_ssh\_key) | Generates a secure private key and encodes it as PEM. | `bool` | `false` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | Map with identity block informations as described here https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#identity | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | <pre>{<br>  "identity_ids": [],<br>  "type": "SystemAssigned"<br>}</pre> | no |
| <a name="input_instances_count"></a> [instances\_count](#input\_instances\_count) | The number of Virtual Machines required. | `number` | `1` | no |
| <a name="input_internal_dns_name_label"></a> [internal\_dns\_name\_label](#input\_internal\_dns\_name\_label) | The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network. | `any` | `null` | no |
| <a name="input_key_vault_certificate_secret_url"></a> [key\_vault\_certificate\_secret\_url](#input\_key\_vault\_certificate\_secret\_url) | The Secret URL of a Key Vault Certificate, which must be specified when `protocol` is set to `Https` | `any` | `null` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | Specifies the type of on-premise license which should be used for this Virtual Machine. Possible values are None, Windows\_Client and Windows\_Server. | `string` | `"None"` | no |
| <a name="input_linux_distribution_list"></a> [linux\_distribution\_list](#input\_linux\_distribution\_list) | Pre-defined Azure Linux VM images list | <pre>map(object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  }))</pre> | <pre>{<br>  "centos77": {<br>    "offer": "CentOS",<br>    "publisher": "OpenLogic",<br>    "sku": "7.7",<br>    "version": "latest"<br>  },<br>  "centos78-gen2": {<br>    "offer": "CentOS",<br>    "publisher": "OpenLogic",<br>    "sku": "7_8-gen2",<br>    "version": "latest"<br>  },<br>  "centos79-gen2": {<br>    "offer": "CentOS",<br>    "publisher": "OpenLogic",<br>    "sku": "7_9-gen2",<br>    "version": "latest"<br>  },<br>  "centos81": {<br>    "offer": "CentOS",<br>    "publisher": "OpenLogic",<br>    "sku": "8_1",<br>    "version": "latest"<br>  },<br>  "centos81-gen2": {<br>    "offer": "CentOS",<br>    "publisher": "OpenLogic",<br>    "sku": "8_1-gen2",<br>    "version": "latest"<br>  },<br>  "centos82-gen2": {<br>    "offer": "CentOS",<br>    "publisher": "OpenLogic",<br>    "sku": "8_2-gen2",<br>    "version": "latest"<br>  },<br>  "centos83-gen2": {<br>    "offer": "CentOS",<br>    "publisher": "OpenLogic",<br>    "sku": "8_3-gen2",<br>    "version": "latest"<br>  },<br>  "centos84-gen2": {<br>    "offer": "CentOS",<br>    "publisher": "OpenLogic",<br>    "sku": "8_4-gen2",<br>    "version": "latest"<br>  },<br>  "coreos": {<br>    "offer": "CoreOS",<br>    "publisher": "CoreOS",<br>    "sku": "Stable",<br>    "version": "latest"<br>  },<br>  "githubEnt": {<br>    "offer": "GitHub-Enterprise",<br>    "publisher": "GitHub",<br>    "sku": "GitHub-Enterprise",<br>    "version": "latest"<br>  },<br>  "mssql2019dev-rhel8": {<br>    "offer": "sql2019-rhel8",<br>    "publisher": "MicrosoftSQLServer",<br>    "sku": "sqldev",<br>    "version": "latest"<br>  },<br>  "mssql2019dev-ubuntu1804": {<br>    "offer": "sql2019-ubuntu1804",<br>    "publisher": "MicrosoftSQLServer",<br>    "sku": "sqldev",<br>    "version": "latest"<br>  },<br>  "mssql2019dev-ubuntu2004": {<br>    "offer": "sql2019-ubuntu2004",<br>    "publisher": "MicrosoftSQLServer",<br>    "sku": "sqldev",<br>    "version": "latest"<br>  },<br>  "mssql2019ent-rhel8": {<br>    "offer": "sql2019-rhel8",<br>    "publisher": "MicrosoftSQLServer",<br>    "sku": "enterprise",<br>    "version": "latest"<br>  },<br>  "mssql2019ent-ubuntu1804": {<br>    "offer": "sql2019-ubuntu1804",<br>    "publisher": "MicrosoftSQLServer",<br>    "sku": "enterprise",<br>    "version": "latest"<br>  },<br>  "mssql2019ent-ubuntu2004": {<br>    "offer": "sql2019-ubuntu2004",<br>    "publisher": "MicrosoftSQLServer",<br>    "sku": "enterprise",<br>    "version": "latest"<br>  },<br>  "mssql2019std-rhel8": {<br>    "offer": "sql2019-rhel8",<br>    "publisher": "MicrosoftSQLServer",<br>    "sku": "standard",<br>    "version": "latest"<br>  },<br>  "mssql2019std-ubuntu1804": {<br>    "offer": "sql2019-ubuntu1804",<br>    "publisher": "MicrosoftSQLServer",<br>    "sku": "standard",<br>    "version": "latest"<br>  },<br>  "mssql2019std-ubuntu2004": {<br>    "offer": "sql2019-ubuntu2004",<br>    "publisher": "MicrosoftSQLServer",<br>    "sku": "standard",<br>    "version": "latest"<br>  },<br>  "rhel78": {<br>    "offer": "RHEL",<br>    "publisher": "RedHat",<br>    "sku": "7.8",<br>    "version": "latest"<br>  },<br>  "rhel78-gen2": {<br>    "offer": "RHEL",<br>    "publisher": "RedHat",<br>    "sku": "78-gen2",<br>    "version": "latest"<br>  },<br>  "rhel79": {<br>    "offer": "RHEL",<br>    "publisher": "RedHat",<br>    "sku": "7.9",<br>    "version": "latest"<br>  },<br>  "rhel79-gen2": {<br>    "offer": "RHEL",<br>    "publisher": "RedHat",<br>    "sku": "79-gen2",<br>    "version": "latest"<br>  },<br>  "rhel81": {<br>    "offer": "RHEL",<br>    "publisher": "RedHat",<br>    "sku": "8.1",<br>    "version": "latest"<br>  },<br>  "rhel81-gen2": {<br>    "offer": "RHEL",<br>    "publisher": "RedHat",<br>    "sku": "81gen2",<br>    "version": "latest"<br>  },<br>  "rhel82": {<br>    "offer": "RHEL",<br>    "publisher": "RedHat",<br>    "sku": "8.2",<br>    "version": "latest"<br>  },<br>  "rhel82-gen2": {<br>    "offer": "RHEL",<br>    "publisher": "RedHat",<br>    "sku": "82gen2",<br>    "version": "latest"<br>  },<br>  "rhel83": {<br>    "offer": "RHEL",<br>    "publisher": "RedHat",<br>    "sku": "8.3",<br>    "version": "latest"<br>  },<br>  "rhel83-gen2": {<br>    "offer": "RHEL",<br>    "publisher": "RedHat",<br>    "sku": "83gen2",<br>    "version": "latest"<br>  },<br>  "rhel84": {<br>    "offer": "RHEL",<br>    "publisher": "RedHat",<br>    "sku": "8.4",<br>    "version": "latest"<br>  },<br>  "rhel84-byos": {<br>    "offer": "rhel-byos",<br>    "publisher": "RedHat",<br>    "sku": "rhel-lvm84",<br>    "version": "latest"<br>  },<br>  "rhel84-byos-gen2": {<br>    "offer": "rhel-byos",<br>    "publisher": "RedHat",<br>    "sku": "rhel-lvm84-gen2",<br>    "version": "latest"<br>  },<br>  "rhel84-gen2": {<br>    "offer": "RHEL",<br>    "publisher": "RedHat",<br>    "sku": "84gen2",<br>    "version": "latest"<br>  },<br>  "ubuntu1604": {<br>    "offer": "UbuntuServer",<br>    "publisher": "Canonical",<br>    "sku": "16.04-LTS",<br>    "version": "latest"<br>  },<br>  "ubuntu1804": {<br>    "offer": "UbuntuServer",<br>    "publisher": "Canonical",<br>    "sku": "18.04-LTS",<br>    "version": "latest"<br>  },<br>  "ubuntu1904": {<br>    "offer": "UbuntuServer",<br>    "publisher": "Canonical",<br>    "sku": "19.04",<br>    "version": "latest"<br>  },<br>  "ubuntu2004": {<br>    "offer": "0001-com-ubuntu-server-focal-daily",<br>    "publisher": "Canonical",<br>    "sku": "20_04-daily-lts",<br>    "version": "latest"<br>  },<br>  "ubuntu2004-gen2": {<br>    "offer": "0001-com-ubuntu-server-focal-daily",<br>    "publisher": "Canonical",<br>    "sku": "20_04-daily-lts-gen2",<br>    "version": "latest"<br>  }<br>}</pre> | no |
| <a name="input_linux_distribution_name"></a> [linux\_distribution\_name](#input\_linux\_distribution\_name) | Variable to pick an OS flavour for Linux based VM. Possible values include: centos8, ubuntu1804 | `string` | `"ubuntu1804"` | no |
| <a name="input_load_balancer_backend_pool_id"></a> [load\_balancer\_backend\_pool\_id](#input\_load\_balancer\_backend\_pool\_id) | Id of the Load Balancer Backend Pool to attach the VM. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region in which instance will be hosted | `string` | n/a | yes |
| <a name="input_log_analytics_resource_id"></a> [log\_analytics\_resource\_id](#input\_log\_analytics\_resource\_id) | The name of log analytics workspace resource id | `any` | `null` | no |
| <a name="input_log_analytics_workspace_primary_shared_key"></a> [log\_analytics\_workspace\_primary\_shared\_key](#input\_log\_analytics\_workspace\_primary\_shared\_key) | The Primary shared key for the Log Analytics Workspace | `any` | `null` | no |
| <a name="input_managed_identity_ids"></a> [managed\_identity\_ids](#input\_managed\_identity\_ids) | A list of User Managed Identity ID's which should be assigned to the Linux Virtual Machine. | `any` | `null` | no |
| <a name="input_managed_identity_type"></a> [managed\_identity\_type](#input\_managed\_identity\_type) | The type of Managed Identity which should be assigned to the Linux Virtual Machine. Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned` | `any` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Optional prefix for the generated name | `string` | `""` | no |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | Optional suffix for the generated name | `string` | `""` | no |
| <a name="input_nic_add_tags"></a> [nic\_add\_tags](#input\_nic\_add\_tags) | Extra tags to set on the network interface. | `map(string)` | `{}` | no |
| <a name="input_nic_enable_accelerated_networking"></a> [nic\_enable\_accelerated\_networking](#input\_nic\_enable\_accelerated\_networking) | Should Accelerated Networking be enabled? Defaults to `false`. | `bool` | `false` | no |
| <a name="input_nic_nsg_id"></a> [nic\_nsg\_id](#input\_nic\_nsg\_id) | NSG ID to associate on the Network Interface. No association if null. | `string` | `null` | no |
| <a name="input_nsg_diag_logs"></a> [nsg\_diag\_logs](#input\_nsg\_diag\_logs) | NSG Monitoring Category details for Azure Diagnostic setting | `list` | <pre>[<br>  "NetworkSecurityGroupEvent",<br>  "NetworkSecurityGroupRuleCounter"<br>]</pre> | no |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | Name of the organization | `string` | n/a | yes |
| <a name="input_os_disk_add_tags"></a> [os\_disk\_add\_tags](#input\_os\_disk\_add\_tags) | Extra tags to set on the OS disk. | `map(string)` | `{}` | no |
| <a name="input_os_disk_caching"></a> [os\_disk\_caching](#input\_os\_disk\_caching) | The Type of Caching which should be used for the Internal OS Disk. Possible values are `None`, `ReadOnly` and `ReadWrite` | `string` | `"ReadWrite"` | no |
| <a name="input_os_disk_custom_name"></a> [os\_disk\_custom\_name](#input\_os\_disk\_custom\_name) | Custom name for OS disk. Generated if not set. | `string` | `null` | no |
| <a name="input_os_disk_name"></a> [os\_disk\_name](#input\_os\_disk\_name) | The name which should be used for the Internal OS Disk | `any` | `null` | no |
| <a name="input_os_disk_overwrite_tags"></a> [os\_disk\_overwrite\_tags](#input\_os\_disk\_overwrite\_tags) | True to overwrite existing OS disk tags instead of merging. | `bool` | `false` | no |
| <a name="input_os_disk_storage_account_type"></a> [os\_disk\_storage\_account\_type](#input\_os\_disk\_storage\_account\_type) | The Type of Storage Account which should back this the Internal OS Disk. Possible values include Standard\_LRS, StandardSSD\_LRS and Premium\_LRS. | `string` | `"StandardSSD_LRS"` | no |
| <a name="input_os_disk_tagging_enabled"></a> [os\_disk\_tagging\_enabled](#input\_os\_disk\_tagging\_enabled) | Should OS disk tagging be enabled? Defaults to `true`. | `bool` | `true` | no |
| <a name="input_patch_mode"></a> [patch\_mode](#input\_patch\_mode) | Specifies the mode of in-guest patching to Linux or Windows Virtual Machine. Possible values are `Manual`, `AutomaticByOS` and `AutomaticByPlatform` | `string` | `"AutomaticByPlatform"` | no |
| <a name="input_platform_fault_domain_count"></a> [platform\_fault\_domain\_count](#input\_platform\_fault\_domain\_count) | Specifies the number of fault domains that are used | `number` | `3` | no |
| <a name="input_platform_update_domain_count"></a> [platform\_update\_domain\_count](#input\_platform\_update\_domain\_count) | Specifies the number of update domains that are used | `number` | `5` | no |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | The Static IP Address which should be used. This is valid only when `private_ip_address_allocation` is set to `Static` | `any` | `null` | no |
| <a name="input_private_ip_address_allocation_type"></a> [private\_ip\_address\_allocation\_type](#input\_private\_ip\_address\_allocation\_type) | The allocation method used for the Private IP Address. Possible values are Dynamic and Static. | `string` | `"Dynamic"` | no |
| <a name="input_public_ip_add_tags"></a> [public\_ip\_add\_tags](#input\_public\_ip\_add\_tags) | Extra tags to set on the public IP resource. | `map(string)` | `{}` | no |
| <a name="input_public_ip_allocation_method"></a> [public\_ip\_allocation\_method](#input\_public\_ip\_allocation\_method) | Defines the allocation method for this IP address. Possible values are `Static` or `Dynamic` | `string` | `"Static"` | no |
| <a name="input_public_ip_availability_zone"></a> [public\_ip\_availability\_zone](#input\_public\_ip\_availability\_zone) | Zones for public IP attached to the VM. Can be `null` if no zone distpatch. | `list(number)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |
| <a name="input_public_ip_sku"></a> [public\_ip\_sku](#input\_public\_ip\_sku) | SKU for the public IP attached to the VM. Can be `null` if no public IP needed. | `string` | `"Standard"` | no |
| <a name="input_public_ip_sku_tier"></a> [public\_ip\_sku\_tier](#input\_public\_ip\_sku\_tier) | The SKU Tier that should be used for the Public IP. Possible values are `Regional` and `Global` | `string` | `"Regional"` | no |
| <a name="input_random_password_length"></a> [random\_password\_length](#input\_random\_password\_length) | The desired length of random password created by this module | `number` | `24` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the workload ressource group | `string` | n/a | yes |
| <a name="input_source_image_id"></a> [source\_image\_id](#input\_source\_image\_id) | The ID of an Image which each Virtual Machine should be based on | `any` | `null` | no |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | SSH private key | `string` | `null` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key | `string` | `null` | no |
| <a name="input_static_private_ip"></a> [static\_private\_ip](#input\_static\_private\_ip) | Static private IP. Private IP is dynamic if not set. | `string` | `null` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The name of the hub storage account to store logs | `any` | `null` | no |
| <a name="input_storage_account_uri"></a> [storage\_account\_uri](#input\_storage\_account\_uri) | The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor. Passing a `null` value will utilize a Managed Storage Account to store Boot Diagnostics. | `any` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_use_naming"></a> [use\_naming](#input\_use\_naming) | Use the Azure CAF naming provider to generate default resource name. `custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| <a name="input_virtual_machine_name"></a> [virtual\_machine\_name](#input\_virtual\_machine\_name) | The name of the virtual machine. | `string` | `""` | no |
| <a name="input_virtual_machine_size"></a> [virtual\_machine\_size](#input\_virtual\_machine\_size) | The Virtual Machine SKU for the Virtual Machine, Default is Standard\_A2\_V2 | `string` | `"Standard_A2_v2"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the virtual network | `string` | `""` | no |
| <a name="input_vm_availability_zone"></a> [vm\_availability\_zone](#input\_vm\_availability\_zone) | The Zone in which this Virtual Machine should be created. Conflicts with availability set and shouldn't use both | `any` | `null` | no |
| <a name="input_vm_subnet_name"></a> [vm\_subnet\_name](#input\_vm\_subnet\_name) | Name of the Subnet in which create the Virtual Machine | `string` | n/a | yes |
| <a name="input_vm_time_zone"></a> [vm\_time\_zone](#input\_vm\_time\_zone) | Specifies the Time Zone which should be used by the Virtual Machine | `any` | `null` | no |
| <a name="input_winrm_protocol"></a> [winrm\_protocol](#input\_winrm\_protocol) | Specifies the protocol of winrm listener. Possible values are `Http` or `Https` | `any` | `null` | no |
| <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name) | Name of the workload\_name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_ssh_key_private"></a> [admin\_ssh\_key\_private](#output\_admin\_ssh\_key\_private) | The generated private key data in PEM format |
| <a name="output_admin_ssh_key_public"></a> [admin\_ssh\_key\_public](#output\_admin\_ssh\_key\_public) | The generated public key data in PEM format |
| <a name="output_linux_virtual_machine_ids"></a> [linux\_virtual\_machine\_ids](#output\_linux\_virtual\_machine\_ids) | The resource id's of all Linux Virtual Machine. |
| <a name="output_linux_vm_password"></a> [linux\_vm\_password](#output\_linux\_vm\_password) | Password for the Linux VM |
| <a name="output_linux_vm_private_ips"></a> [linux\_vm\_private\_ips](#output\_linux\_vm\_private\_ips) | Public IP's map for the all linux Virtual Machines |
| <a name="output_linux_vm_public_ips"></a> [linux\_vm\_public\_ips](#output\_linux\_vm\_public\_ips) | Public IP's map for the all linux Virtual Machines |
| <a name="output_network_security_group_ids"></a> [network\_security\_group\_ids](#output\_network\_security\_group\_ids) | List of Network security groups and ids |
| <a name="output_terraform_module"></a> [terraform\_module](#output\_terraform\_module) | Information about this Terraform module |
| <a name="output_vm_availability_set_id"></a> [vm\_availability\_set\_id](#output\_vm\_availability\_set\_id) | The resource ID of Virtual Machine availability set |
<!-- END_TF_DOCS -->