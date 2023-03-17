# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Azure Region Lookup
#----------------------------------------------------------
module "mod_azregions" {
  source  = "azurenoops/overlays-azregions-lookup/azurerm"
  version = "~> 1.0.0"

  azure_region = var.location
}

#---------------------------------------------------------
# Resource Group Creation
#----------------------------------------------------------
data "azurerm_resource_group" "vm_rgrp" {
  count = var.create_vm_resource_group == false ? 1 : 0
  name  = var.custom_vm_resource_group_name
}

module "mod_vm_rg" {
  source  = "azurenoops/overlays-resource-group/azurerm"
  version = "~> 1.0.1"

  count = var.create_vm_resource_group ? 1 : 0

  location                = module.mod_azregions.location_cli
  use_location_short_name = var.use_location_short_name # Use the short location name in the resource group name
  org_name                = var.org_name
  environment             = var.deploy_environment
  workload_name           = var.workload_name
  custom_rg_name          = var.custom_vm_resource_group_name != null ? var.custom_vm_resource_group_name : null

  // Tags
  add_tags = merge(var.tags, {
    DeployedBy = format("AzureNoOpsTF [%s]", terraform.workspace)
  }) # Tags to be applied to all resources
}
