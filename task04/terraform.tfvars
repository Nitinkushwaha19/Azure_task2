resource_group_name         = "cmaz-2ehw6cyk-mod4-rg"
resource_group_location     = "East US"
virtual_network_name        = "cmaz-2ehw6cyk-mod4-vnet"
virtual_network_subnet_name = "frontend"
dns_name_label              = "cmaz-2ehw6cyk-mod4-nginx"
public_ip_name              = "cmaz-2ehw6cyk-mod4-pip"
network_security_group_name = "cmaz-2ehw6cyk-mod4-nsg"
network_interface_name      = "cmaz-2ehw6cyk-mod4-nic"
linux_vm_name               = "cmaz-2ehw6cyk-mod4-vm"
vm_size                     = "Standard_B2s_v2"
admin_username              = "azureuser"
tags = {
  Creator = "nitin_ajaykushwaha@epam.com"
}

nsg_http_rule = "AllowHTTP"
nsg_ssh_rule  = "AllowSSH"
