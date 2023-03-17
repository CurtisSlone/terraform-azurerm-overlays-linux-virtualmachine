terraform {
  # This module is now only being tested with Terraform 1.3. However, to make upgrading easier, we are setting
  # 1.2 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 1.3.x code.
  required_version = ">= 1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.22"
    }
    azurenoopsutils = {
      source  = "azurenoops/azurenoopsutils"
      version = "~> 1.0.4"
    }
  }
}

provider "azurerm" {
  features {}
}
