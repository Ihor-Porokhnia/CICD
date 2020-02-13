
provider "google" {}


resource "google_sql_database_instance" "master" {
  name             = "master-instance"
  database_version = "POSTGRES_11"
  region           = "us-central1"

  settings {
    
    tier = "db-f1-micro"
  }
}

