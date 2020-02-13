
provider "google" {}


resource "google_sql_database_instance" "master" {
  name             = "master-sql"
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

