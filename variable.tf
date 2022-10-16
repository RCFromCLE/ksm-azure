variable "sub_id"{
    description = "id of Azure subscription"
    type = string
}
variable "rg-01_name"{
    description = "name of resource group"
    type = string
}
variable "rg-01_location"{
    description = "location of resource group"
    type = string
    default = "East US"
}
variable "tags"{
    description = "tags for resources"
    type = map
    default = {
        source = "terraform"
        app = "ksm"
    }
} 
variable "vnet_name" {
description = "name of virtual network"
type = string
}
variable "vnet_address_space" {
    description = "address space used for virtual network"
    type = list
}
variable "subnet_name" {
    description = "name of subnet"
    type = string
}
variable "subnet_address_space" {
    description = "address space of subnet"
    type = list
}
variable "nic01_name" {
    description = "name of network interface in azure to vm"
    type = string
    default = "nic-01"
}
variable "ipconfig_name" {
    description = "name of network interface in vm"
    type = string
    default = "internal"
}
variable "priv_ip_alloc" {
    description = "dhcp or static for network address assignment"
    type = string
    default = "dynamic"
}
variable "vm01_name" {
    description = "name of virtual machine"
    type = string
}
variable "sku_size" {
  description = "sku used for virtual machine sizing" 
  type = string 
}
variable "admin_user"{
    description = "admin username for the virtual machine"
    type = string
}
variable "pub_key" { 
    description = "ssh key used to authenticate to virtual machine"
    type = string
    default = "~/.ssh/id_rsa.pub"
}
variable "disk_caching" {
    description = "disk caching"
    type = string
    default = "ReadWrite"
}
variable "stg_acct_type" {
    description = "type of storage account"
    type = string
    default = "Standard_LRS"
}
variable "publisher" {
    description = "required"
    type = string
}
variable "offer" {
    description = "Type of server image"
    type = string
}
variable "sku" {
    type = string
    description = "os image name"
} 
variable "os_version" {
    description = "version of OS image"
    type = string
}