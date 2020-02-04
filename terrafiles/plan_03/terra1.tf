provider "google" {}


resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "n1-standard-1"

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
}
