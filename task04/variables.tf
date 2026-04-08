# Resource group 
variable "resource_group_name" {
  type        = string
  description = "name of the resource group."
}

variable "tags" {
  type        = map(string)
  description = "tags to be applied to the resources"
}

variable "resource_group_location" {
  type        = string
  description = "location of the resource group"
}


# Virtual network
variable "virtual_network_name" {
  type        = string
  description = "name of the virtual network"
}

# subnet
variable "virtual_network_subnet_name" {
  type        = string
  description = "name of the subnet"
}

# public IP
variable "dns_name_label" {
  type        = string
  description = "DNS name label for the public IP address"
}

variable "public_ip_name" {
  type        = string
  description = "name of the public ip"
}

# Network security group
variable "network_security_group_name" {
  type        = string
  description = "name of the network security group"
}

variable "nsg_http_rule" {
  type        = string
  description = "name of the NSG rule to allow HTTP traffic"
}

variable "nsg_ssh_rule" {
  type        = string
  description = "name of the NSG rule to allow SSH traffic"
}

# Network Interface
variable "network_interface_name" {
  type        = string
  description = "name of the network interface"
}

variable "network_interface_ip_configuration_name" {
  type        = string
  description = "name of the network interface IP configuration"
  default     = "internal"
}

# Virtual Machine
variable "linux_vm_name" {
  type        = string
  description = "name of the Linux virtual machine"
}

variable "vm_size" {
  type        = string
  description = "size of the virtual machine"
}

variable "admin_username" {
  type        = string
  description = "admin username for the virtual machine"
}

variable "vm_password" {
  type        = string
  sensitive   = true
  description = "admin password for the virtual machine"
}

