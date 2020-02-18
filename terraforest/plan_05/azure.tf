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
  
  os_type             = "Linux"

  container {
    name             = "nginx"
    image            = "bugoga/noginsk:latest"
    cpu              = "0.5"
    memory           = "1.5"    
    ports {
      port     = 443
      protocol = "TCP"
    }
    ports {
      port     = 80
      protocol = "TCP"
    }
    

  }
  
    container {
    name             = "tomcat"
    image            = "bugoga/tomat:latest"
    cpu              = "0.5"
    memory           = "1.5"    
    ports {
      port     = 8080
      protocol = "TCP"
    }

    

  }


  tags = {
    environment = "testing"
  }
}
