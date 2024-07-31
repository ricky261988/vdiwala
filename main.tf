provider "azurerm" {
  subscription_id = "ae2528e2-32eb-4bee-abcd-052d1e2a9d45"
  client_id = "a9a7ea9b-dd44-4321-8439-d83df3a6dd3c"
  client_secret = "23w8Q~-Uo8rfKXa-2gzeKmPPf~7P3ox-Hu-6sboo"
  tenant_id = "25cc363b-77f0-4ff0-92ba-7d222ef0dcec"
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "Kishan-ResourceGroup"
  location = "Central India"
}

resource "azurerm_virtual_network" "example" {
  name                = "Kishan-VNET"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "Kishan-Subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes    = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "Kishan-NIC"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "example" {
  name                  = "Kishan-VM"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_B1s"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "exampleOSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
