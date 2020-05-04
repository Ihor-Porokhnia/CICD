terraform {
  backend "s3" {
    bucket = "terraforms3backend01"
    key    = "devexp/terraform.tfstate"
    region = "eu-north-1"
  }
}
