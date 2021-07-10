# Create network
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network

resource "azurerm_virtual_network" "myNet" {
    name                = "kubernetesnet"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    tags = {
        environment = "CP2"
    }
}

# Create subnet
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet

resource "azurerm_subnet" "mySubnet" {
    name                   = "terraformsubnet"
    resource_group_name    = azurerm_resource_group.rg.name
    virtual_network_name   = azurerm_virtual_network.myNet.name
    address_prefixes       = ["10.0.1.0/24"]

}


# Create NIC
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface

# Create NIC for master and nfs
resource "azurerm_network_interface" "myNicMasterNfs" {
  name                = "vmnic-master-nfs"  
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
    name                           = "myipconfiguration-master-nfs"
    subnet_id                      = azurerm_subnet.mySubnet.id 
    private_ip_address_allocation  = "Static"
    private_ip_address             = "10.0.1.10"
    public_ip_address_id           = azurerm_public_ip.myPublicIpMasterNfs.id
  }

    tags = {
        environment = "CP2"
    }
}

# Create NIC for workers

resource "azurerm_network_interface" "myNicWorkers" {
  count               = length(var.vm_workers)
  name                = "vmnic-${var.vm_workers[count.index]}" 
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
    name                           = "myipconfiguration-${var.vm_workers[count.index]}"
    subnet_id                      = azurerm_subnet.mySubnet.id 
    private_ip_address_allocation  = "Static"
    private_ip_address             = "10.0.1.${count.index + 11}"
    public_ip_address_id           = azurerm_public_ip.myPublicIpWorkers[count.index].id
  }

    tags = {
        environment = "CP2"
    }
}

# Create public IP
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip

# Create public IP for master

resource "azurerm_public_ip" "myPublicIpMasterNfs" {
  name                = "vmip1-masterNfs"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

    tags = {
        environment = "CP2"
    }
}


# Create public IP for workers

resource "azurerm_public_ip" "myPublicIpWorkers" {
  count               = length(var.vm_workers)
  name                = "vmip1-${var.vm_workers[count.index]}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

    tags = {
        environment = "CP2"
    }
}