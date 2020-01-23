provider "cloudflare" {
  version = "~> 2.0"
}

resource "cloudflare_record" "www" {

  zone_id = "cb31e9f86a3d9b6579e64701c6e4a95b"
  name    = "www"
  value   = "203.0.113.10"
  type    = "A"
  proxied = false
}
