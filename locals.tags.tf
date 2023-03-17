# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Local Tags configuration - Default (required). 
#------------------------------------------------------------

locals {
  default_tags = var.default_tags_enabled ? {
    deployedBy  = format("AzureNoOpsTF [%s]", terraform.workspace)
    environment = var.environment
    workload    = var.workload_name
  } : {}

  default_vm_tags = var.default_tags_enabled ? {
    os_family       = "linux"
    } : {}
}
