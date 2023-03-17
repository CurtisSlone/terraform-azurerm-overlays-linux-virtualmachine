resource "azurerm_virtual_network" "example" {
  name                = "vm-network"
  location            = var.location
  resource_group_name = module.mod_linux_vm.linux_vm_resource_group_name
  address_space       = ["10.0.0.0/16"]
  tags = {
    environment = "test"
  }
}

resource "azurerm_subnet" "example" {
  name                 = "vm-subnet"
  resource_group_name  = module.mod_linux_vm.linux_vm_resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}