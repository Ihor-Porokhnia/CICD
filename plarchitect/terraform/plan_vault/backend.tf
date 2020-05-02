terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    
    organization = "iptools"

    workspaces {
      name = "remo01"
    }
    
  }
}
