terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
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
  tags     = var.tags
}
# deploy virtual network
resource "azurerm_virtual_network" "vnet-01" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg-01.location
  resource_group_name = var.rg-01_name
}
# deploy subnet
resource "azurerm_subnet" "subnet-01" {
  name                 = var.subnet_name
  resource_group_name  = var.rg-01_name
  virtual_network_name = azurerm_virtual_network.vnet-01.name
  address_prefixes     = var.subnet_address_space
}
# resource "azurerm_subnet" "subnet-02" {
#   name                 = var.subnet2_name
#   resource_group_name  = var.rg-01_name
#   virtual_network_name = azurerm_virtual_network.vnet-01.name
#   address_prefixes     = var.subnet2_address_space
# }
# deploy network security group
resource "azurerm_network_security_group" "nsg-01" {
  name                = var.nsg-01_name
  location            = azurerm_resource_group.rg-01.location
  resource_group_name = var.rg-01_name

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
resource "azurerm_public_ip" "pub_ip01" {
  name                = var.public_ip-01_name 
  resource_group_name = var.rg-01_name
  location            = var.rg-01_location
  allocation_method   = var.allocation_method
  sku                 = var.sku_ip

}
output "public_ip_address" {
  depends_on = [
    azurerm_public_ip.pub_ip01
  ]
  value = "${azurerm_public_ip.pub_ip01.*.ip_address}"
}
resource "azurerm_network_security_rule" "outbound-all" {
  name                        = "ssh"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-01_name
  network_security_group_name = var.nsg-01_name
}

resource "azurerm_network_security_rule" "sshIn" {
  name                        = "sshIn"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.ssh_allowed_ip_range
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-01_name
  network_security_group_name = var.nsg-01_name
}

resource "azurerm_network_security_rule" "p2pIn" {
  name                        = "p2pIn"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "30333"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-01_name
  network_security_group_name = var.nsg-01_name
}

resource "azurerm_network_security_rule" "p2pIn-proxy" {
  name                        = "p2pIn-proxy"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-01_name
  network_security_group_name = var.nsg-01_name
}

resource "azurerm_network_security_rule" "vpnIn" {
  name                        = "vpnIn"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "51820"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-01_name
  network_security_group_name = var.nsg-01_name
}

resource "azurerm_network_security_rule" "node-exporter" {
  name                        = "nodeExporterIn"
  priority                    = 104
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9100"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-01_name
  network_security_group_name = var.nsg-01_name
}

resource "azurerm_network_security_rule" "node-exporter2" {
  name                        = "nodeMetricsIn"
  priority                    = 105
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9616"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-01_name
  network_security_group_name = var.nsg-01_name

}
# associate subnet-01 with network security group
resource "azurerm_subnet_network_security_group_association" "subnet-assoc-01" {
  subnet_id                 = azurerm_subnet.subnet-01.id
  network_security_group_id = azurerm_network_security_group.nsg-01.id
}
# associate subnet-02 with network security group
# resource "azurerm_subnet_network_security_group_association" "subnet-assoc-02" {
#   subnet_id                 = azurerm_subnet.subnet-02.id
#   network_security_group_id = azurerm_network_security_group.nsg-01.id
# }
# deploy nic for vm 1
resource "azurerm_network_interface" "nic-01" {
  name                = var.nic01_name
  location            = azurerm_resource_group.rg-01.location
  resource_group_name = var.rg-01_name

  ip_configuration {
    name                          = var.ipconfig_name
    subnet_id                     = azurerm_subnet.subnet-01.id
    private_ip_address_allocation = var.priv_ip_alloc
    public_ip_address_id          = azurerm_public_ip.pub_ip01.id
  }
  depends_on = [
    azurerm_public_ip.pub_ip01
  ]
}
# deploy nic for vm 2
# resource "azurerm_network_interface" "nic-02" {
#   name                = var.nic02_name
#   location            = azurerm_resource_group.rg-01.location
#   resource_group_name = var.rg-01_name

#   ip_configuration {
#     name                          = var.ipconfig_name
#     subnet_id                     = azurerm_subnet.subnet-02.id
#     private_ip_address_allocation = var.priv_ip_alloc
#   }
# }

# deploy ubuntu virtual machine
resource "azurerm_linux_virtual_machine" "vm-01" {
  name                = var.vm01_name
  resource_group_name = var.rg-01_name
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
    disk_size_gb         = var.disk_size
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
  override_special = "()[]{}<>"
}
output "output_password" {
  value     = random_password.password.result
  sensitive = true
}
# associate virtual machine with network secrity group
resource "azurerm_network_interface_security_group_association" "nic01_nsg01" {
  network_interface_id      = azurerm_network_interface.nic-01.id
  network_security_group_id = azurerm_network_security_group.nsg-01.id
}

# resource "azurerm_windows_virtual_machine" "vm-02" {
#   name                = var.vm02_name
#   resource_group_name = var.rg-01_name
#   location            = azurerm_resource_group.rg-01.location
#   size                = var.sku_size
#   admin_username      = var.admin_user
#   admin_password      = random_password.password.result
#   network_interface_ids = [
#     azurerm_network_interface.nic-02.id,
#   ]

#   os_disk {
#     caching              = var.disk_caching
#     storage_account_type = var.stg_acct_type
#   }
#   # build Windows admin server
#   source_image_reference {
#     publisher = var.publisher2
#     offer     = var.offer2
#     sku       = var.sku2
#     version   = var.os_version
#   }

# }
# # subnet for bastion
# resource "azurerm_subnet" "bastion-subnet" {
#   name                 = "AzureBastionSubnet"
#   resource_group_name  = var.rg-01_name
#   virtual_network_name = azurerm_virtual_network.vnet-01.name
#   address_prefixes     = var.subnet3_address_space
# }
# # public ip for bastion
# resource "azurerm_public_ip" "public-ip" {
#   name                = var.bastion_ip_name
#   location            = azurerm_resource_group.rg-01.location
#   resource_group_name = var.rg-01_name
#   allocation_method   = var.allocation_method
#   sku                 = var.sku_ip
# }
# # create bastion host
# resource "azurerm_bastion_host" "bastion" {
#   name                = var.bastion_instance_name
#   location            = azurerm_resource_group.rg-01.location
#   resource_group_name = var.rg-01_name

#   ip_configuration {
#     name                 = var.bastion_ip_configuration
#     subnet_id            = azurerm_subnet.bastion-subnet.id
#     public_ip_address_id = azurerm_public_ip.public-ip.id
#   }
# }