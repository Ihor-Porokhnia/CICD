provider "cloudflare" {
  version = "~> 2.0"
}



resource "cloudflare_record" "azur" {

  zone_id = "cb31e9f86a3d9b6579e64701c6e4a95b"
  name    = "azure"
  value   = "${azurerm_container_group.cg.ip_address}"
  type    = "A"
  proxied = false
}

