provider "google" {}


resource "google_container_cluster" "kubernetes" {
  name               = "k8s-cluster"
#  depends_on         = ["google_project_service.kubernetes"]
  initial_node_count = 1

  master_auth {
    username = ""
    password = ""
  }

}

