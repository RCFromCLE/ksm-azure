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
  name     = "${var.rg-01_name}"
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
# deploy nic for virtual machine that will be created below
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

