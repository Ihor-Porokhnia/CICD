provider "cloudflare" {
  version = "~> 2.0"
}
variable "domain" {
  default = "bugoga.ga"
}

resource "cloudflare_record" "www" {
  domain  = "${var.domain}"
  name    = "www"
  value   = "203.0.113.10"
  type    = "A"
  proxied = false
}
