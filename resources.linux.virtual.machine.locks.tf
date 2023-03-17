# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Virtual Machine Lock configuration - Default (required). 
#------------------------------------------------------------
resource "azurerm_management_lock" "laws_resource_group_level_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "${local.vm_name}-${var.lock_level}-lock"
  scope      = azurerm_linux_virtual_machine.linux_vm[count.index].id
  lock_level = var.lock_level
  notes      = "Virtual Machine '${local.vm_name}' is locked with '${var.lock_level}' level."
}
