provider "aws" {
  region = "eu-north-1"
  access_key = "${var.aws_id}"
  secret_key = "${var.aws_secret}"
}


resource "aws_instance" "myUbuntu" {
  
  ami           = "ami-1dab2163"
  instance_type = "t3.micro"

}

variable "aws_id" {
  type    = string
  default = "a"
}

variable "aws_secret" {
  type    = string
  default = "a"
}
