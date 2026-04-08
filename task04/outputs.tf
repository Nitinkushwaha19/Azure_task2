output "vm_public_ip" {
  description = "Public IP address of the virtual machine"
  value       = azurerm_public_ip.publicIP.ip_address
}

output "vm_fqdn" {
  description = "Fully Qualified Domain Name of the virtual machine"
  value       = azurerm_public_ip.publicIP.fqdn
}

output "ssh_connection_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.publicIP.ip_address}"
}

output "nginx_url" {
  description = "URL to access Nginx web server"
  value       = "http://${azurerm_public_ip.publicIP.fqdn}"
}

output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.RG.name
}
