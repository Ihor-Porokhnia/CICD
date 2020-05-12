provider "cloudflare" {
  version = "~> 2.0"
}



resource "cloudflare_record" "mysql" {

  zone_id = "cb31e9f86a3d9b6579e64701c6e4a95b"
  name    = "sql"
  value   = "${google_sql_database_instance.master.public_ip_address}"
  type    = "A"
  proxied = false
}
