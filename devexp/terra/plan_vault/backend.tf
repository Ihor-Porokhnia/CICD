terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    
    organization = "iptools"

    workspaces {
      name = "remo01"
    }
    //oken = "yMofyIDRtjCkiA.atlasv1.8cCnT3KzARYR3lez4g82TheJawFa9K8RWRtfoJpNFiTPqyCaelIYGgpZdvCnXAYZskA"
  }
}
