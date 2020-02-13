
provider "google" {}

resource "google_sql_database_instance" "master" {
  name             = "master-suyaster"
  database_version = "MYSQL_5_7"
  region           = "europe-north1"

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = "true"
      authorized_networks {
        value           = "0.0.0.0/0"
        name            = "main"
        
      }
    }
  }
}

resource "google_sql_database" "sd" {
  name     = "SimpleDatabase"
  instance = "${google_sql_database_instance.master.name}"
}

resource "google_sql_user" "remmie" {
  name     = "remmie"
  instance = "${google_sql_database_instance.master.name}"
  host     = "%"
  password = "nemA_666"
}

