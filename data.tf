# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# By default, this module will not create a resource group
# provide a name to use an existing resource group, specify the existing resource group name,
# and set the argument to `create_vm_resource_group = false`. Location will be same as existing RG.

#----------------------------------------------------------
# Resource Group, VNet, Subnet selection
#----------------------------------------------------------
data "azurerm_storage_account" "storeacc" {
  count               = var.enable_boot_diagnostics ? 1 : 0
  name                = var.storage_account_name
  resource_group_name = local.resource_group_name
}
