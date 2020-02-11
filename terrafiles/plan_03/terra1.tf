provider "google" {}


resource "google_container_cluster" "primary" {
  name = "k8s-epam"

  initial_node_count = 2

  master_auth {
    username = "admin"
    password = "fortythousandsofmonkeys"
  }



  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials k8s-epam"
  }
}

resource "google_compute_address" "k8s_address" {
  name = "k8s-web-addr"
  region = "europe-north1"
}


