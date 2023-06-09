variable "location" {
  description = "Azure region in which instance will be hosted"
  type        = string
  default = "eastus"
}

variable "environment" {
  description = "Name of the workload's environnement"
  type        = string
  default = "dev"
}

variable "workload_name" {
  description = "Name of the workload_name"
  type        = string
  default = "test"
}

variable "org_name" {
  description = "Name of the organization"
  type        = string
  default = "anoa"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "admin_username" {
  description = "The username of the local administrator used for the Virtual Machine."
  default     = "azureadmin"
}

variable "virtual_machine_size" {
  description = "The Virtual Machine SKU for the Virtual Machine, Default is Standard_A2_V2"
  default     = "Standard_A2_v2"
}