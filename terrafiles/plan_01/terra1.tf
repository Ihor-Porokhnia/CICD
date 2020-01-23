provider "cloudflare" {
  version = "~> 2.0"
}

resource "cloudflare_record" "www" {
  domain  = "bugoga.ga"
  name    = "www"
  value   = "203.0.113.10"
  type    = "A"
  proxied = false
}
