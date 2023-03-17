output "private_ip" {
  value = module.mod_linux_vm.linux_vm_private_ips
}

output "resource_group_name" {
  value = module.mod_linux_vm.linux_vm_resource_group_name
}

output "vm_name" {
  value = module.mod_linux_vm.linux_vm_name
}

output "vm_size" {
  value = module.mod_linux_vm.linux_vm_size
}
