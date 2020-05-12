provider "cloudflare" {
  version = "~> 2.0"
}



resource "cloudflare_record" "kubehost" {

  zone_id = "cb31e9f86a3d9b6579e64701c6e4a95b"
  name    = "k8shost"
  value   = "${google_container_cluster.primary.endpoint}"
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "kubepoint" {

  zone_id = "cb31e9f86a3d9b6579e64701c6e4a95b"
  name    = "k8s"
  value   = "${google_compute_address.k8s_address.address}"
  type    = "A"
  proxied = false
}

