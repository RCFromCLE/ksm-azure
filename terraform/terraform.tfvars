sub_id                   = "97ab89f2-7aaf-4a7f-bd87-967ca7f9f3ad"
rg-01_name               = "ksm-validator-rg"
vnet_name                = "main-vnet"
nsg-01_name              = "ksm-validator-nsg"
bastion_ip_name          = "bastion-ip"
bastion_instance_name    = "bastion"
vnet_address_space       = ["10.0.0.0/16"]
subnet_name              = "internal-subnet"
subnet2_name             = "admin-subnet"
subnet_address_space     = ["10.0.2.0/24"]
subnet2_address_space    = ["10.0.3.0/28"]
subnet3_address_space    = ["10.0.4.0/29"]
vm01_name                = "val-ubu-01"
vm02_name                = "admin-win-01"
sku_size                 = "Standard_B2s"
admin_user               = "rc"
stg_acct_type            = "Standard_LRS"
publisher                = "Canonical"
offer                    = "UbuntuServer"
sku                      = "18.04-LTS"
os_version               = "latest"
publisher2               = "MicrosoftWindowsServer"
offer2                   = "WindowsServer"
sku2                     = "2022-Datacenter"
sku_ip                   = "Standard"
allocation_method        = "Static"
bastion_ip_configuration = "bastion-ip-configuration"
public_ip-01_name        = "ksm-validator-ip01"
public_ip_count          = "1"
ssh_allowed_ip_range     = "71.31.64.0/18"
