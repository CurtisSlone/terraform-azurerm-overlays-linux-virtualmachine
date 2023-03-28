# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Local configuration - Default (required). 
#------------------------------------------------------------

locals {
  backup_resource_group_name = var.backup_policy_id != null ? split("/", var.backup_policy_id)[4] : null
  backup_recovery_vault_name = var.backup_policy_id != null ? split("/", var.backup_policy_id)[8] : null
  domain_name_label = lower(coalesce(var.internal_dns_name_label, local.vm_name))
}