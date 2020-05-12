/*
This is config file 4 using remote backend with local exec
*/

terraform {
  backend "remote" {
    hostname = "app.terraform.io"    
    organization = "iptools"
    workspaces {
      name = "devexp"
    }    
  }
}
