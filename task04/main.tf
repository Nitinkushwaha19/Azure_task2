# Resource group
resource "azurerm_resource_group" "RG" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags     = var.tags
}

# Virtual network
resource "azurerm_virtual_network" "VNet" {
  name                = var.virtual_network_name
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

# subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.virtual_network_subnet_name
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.VNet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "publicIP" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = var.dns_name_label
  tags                = var.tags
}


# Network security group
resource "azurerm_network_security_group" "NSG" {
  name                = var.network_security_group_name
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  tags                = var.tags
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = var.nsg_ssh_rule
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.RG.name
  network_security_group_name = azurerm_network_security_group.NSG.name
}

resource "azurerm_network_security_rule" "http" {
  name                        = var.nsg_http_rule
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.RG.name
  network_security_group_name = azurerm_network_security_group.NSG.name
}


# Network Interface
resource "azurerm_network_interface" "NIC" {
  name                = var.network_interface_name
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  tags                = var.tags

  ip_configuration {
    name                          = var.network_interface_ip_configuration_name
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicIP.id
  }
}

resource "azurerm_network_interface_security_group_association" "NIC_main" {
  network_interface_id      = azurerm_network_interface.NIC.id
  network_security_group_id = azurerm_network_security_group.NSG.id
}

# Linux virtual machine
resource "azurerm_linux_virtual_machine" "VM" {
  name                = var.linux_vm_name
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  size                = var.vm_size
  admin_username      = var.admin_username
  tags                = var.tags

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.NIC.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  admin_password = var.vm_password

  # Install and configure Nginx using remote-exec provisioner
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
      "sudo ufw allow 'Nginx Full'",
      "sudo ufw allow OpenSSH",
      "echo '<h1>Welcome to nginx!</h1>' | sudo tee /var/www/html/index.html",
      "echo '<p>VM Name: ${var.linux_vm_name}</p>' | sudo tee -a /var/www/html/index.html",
      "echo '<p>Deployed with Terraform</p>' | sudo tee -a /var/www/html/index.html",
      "echo '<p>Creator: nitin_ajaykushwaha@epam.com</p>' | sudo tee -a /var/www/html/index.html",
      "sudo systemctl reload nginx"
    ]

    connection {
      type     = "ssh"
      host     = azurerm_public_ip.publicIP.ip_address
      user     = var.admin_username
      password = var.vm_password
      timeout  = "5m"
    }
  }

  depends_on = [
    azurerm_network_interface_security_group_association.NIC_main
  ]
}
