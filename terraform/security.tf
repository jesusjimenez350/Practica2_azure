# Security group
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group


resource "azurerm_network_security_group" "mySecGroupMasterNfs" {
    name                = "sshtraffic-master-nfs"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "CP2"
    }
}


resource "azurerm_network_security_group" "mySecGroupWorkers" {
    count               = length(var.vm_workers)
    name                = "sshtraffic-${var.vm_workers[count.index]}"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "CP2"
    }
}

# Vinculamos el security group al interface de red
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association

resource "azurerm_network_interface_security_group_association" "mySecGroupAssociationMasterNfs" {
    network_interface_id      = azurerm_network_interface.myNicMasterNfs.id
    network_security_group_id = azurerm_network_security_group.mySecGroupMasterNfs.id

}


resource "azurerm_network_interface_security_group_association" "mySecGroupAssociationWorkers" {
    count                     = length(var.vm_workers)
    network_interface_id      = azurerm_network_interface.myNicWorkers[count.index].id
    network_security_group_id = azurerm_network_security_group.mySecGroupWorkers[count.index].id

}
