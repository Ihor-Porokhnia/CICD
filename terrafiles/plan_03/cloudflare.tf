provider "cloudflare" {
  version = "~> 2.0"
}


resource "cloudflare_record" "kube" {

  zone_id = "cb31e9f86a3d9b6579e64701c6e4a95b"
  name    = "k8s"
  value   = "${google_container_cluster.primary.endpoint}"
  type    = "A"
  proxied = false
}
