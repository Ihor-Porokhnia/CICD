
provider "google" {}

resource "google_sql_database_instance" "master" {
  name             = "master-huyaster"
  database_version = "MYSQL_5_7"
  region           = "europe-north1"

  settings {
    tier = "db-f1-micro"
  }
}

