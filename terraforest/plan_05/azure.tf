provider "azurerm" {}


resource "azurerm_resource_group" "rg" {
  name     = "containers"
  location = "North Europe"
}

resource "azurerm_container_group" "cg" {
  name                = "example-continst"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "public"
  dns_name_label      = "aci-label"
  os_type             = "Linux"

  container {
    name             = "nginx"
    image            = "microsoft/aci-helloworld:latest"
    cpu              = "0.5"
    memory           = "1.5"
    network_protocol = "tcp"
    ports            = ["80", "443"]

  }



  tags = {
    environment = "testing"
  }
}
