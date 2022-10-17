terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.27.0"
      
    }
  }
}
provider "azurerm" {
    features {}
subscription_id = var.sub_id
}
# deploy resource group for solution
resource "azurerm_resource_group" "rg-01" {
  name     = var.rg-01_name
  location = var.rg-01_location
  tags = var.tags
}
# deploy virtual network
resource "azurerm_virtual_network" "vnet-01" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg-01.location
  resource_group_name = azurerm_resource_group.rg-01.name
}
# deploy subnet
resource "azurerm_subnet" "subnet-01" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg-01.name
  virtual_network_name = azurerm_virtual_network.vnet-01.name
  address_prefixes     = var.subnet_address_space
}
resource "azurerm_subnet" "subnet-02" {
  name                 = var.subnet2_name
  resource_group_name  = azurerm_resource_group.rg-01.name
  virtual_network_name = azurerm_virtual_network.vnet-01.name
  address_prefixes     = var.subnet2_address_space
}
# deploy network security group
resource "azurerm_network_security_group" "nsg-01" {
  name                = "ksm-validator-nsg"
  location            = azurerm_resource_group.rg-01.location
  resource_group_name = azurerm_resource_group.rg-01.name

  # security_rule {
  #   name                       = "test123"
  #   priority                   = 100
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "*"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # }
}
# associate subnet-01 with network security group
resource "azurerm_subnet_network_security_group_association" "subnet-assoc-01" {
  subnet_id                 = azurerm_subnet.subnet-01.id
  network_security_group_id = azurerm_network_security_group.nsg-01.id
}
# associate subnet-02 with network security group
resource "azurerm_subnet_network_security_group_association" "subnet-assoc-02" {
  subnet_id                 = azurerm_subnet.subnet-02.id
  network_security_group_id = azurerm_network_security_group.nsg-01.id
}
# deploy nic for vm 1
resource "azurerm_network_interface" "nic-01" {
  name                = var.nic01_name
  location            = azurerm_resource_group.rg-01.location
  resource_group_name = azurerm_resource_group.rg-01.name

  ip_configuration {
    name                          = var.ipconfig_name
    subnet_id                     = azurerm_subnet.subnet-01.id
    private_ip_address_allocation = var.priv_ip_alloc
  }
}
# deploy nic for vm 2
resource "azurerm_network_interface" "nic-02" {
  name                = var.nic02_name
  location            = azurerm_resource_group.rg-01.location
  resource_group_name = azurerm_resource_group.rg-01.name

  ip_configuration {
    name                          = var.ipconfig_name
    subnet_id                     = azurerm_subnet.subnet-02.id
    private_ip_address_allocation = var.priv_ip_alloc
  }
}

# deploy ubuntu virtual machine
resource "azurerm_linux_virtual_machine" "vm-01" {
  name                = var.vm01_name
  resource_group_name = azurerm_resource_group.rg-01.name
  location            = azurerm_resource_group.rg-01.location
  size                = var.sku_size
  admin_username      = var.admin_user
  network_interface_ids = [
    azurerm_network_interface.nic-01.id,
  ]

  admin_ssh_key {
    username   = var.admin_user
    public_key = file(var.pub_key)
  }

  os_disk {
    caching              = var.disk_caching
    storage_account_type = var.stg_acct_type
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.os_version
  }
}
resource "random_password" "password" {
  length           = 8
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
output "output_password" {
value = random_password.password.result
sensitive = true
}

  resource "azurerm_windows_virtual_machine" "vm-02" {
  name                = var.vm02_name
  resource_group_name = azurerm_resource_group.rg-01.name
  location            = azurerm_resource_group.rg-01.location
  size                = var.sku_size
  admin_username      = var.admin_user
  admin_password      = random_password.password.result
  network_interface_ids = [
    azurerm_network_interface.nic-02.id,
  ]

  os_disk {
    caching              = var.disk_caching
    storage_account_type = var.stg_acct_type
  }
# Build Windows admin server
  source_image_reference {
    publisher = var.publisher2
    offer     = var.offer2
    sku       = var.sku2
    version   = var.os_version
  }

}

