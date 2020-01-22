provider "aws" {}


resource "aws_instance" "nodes" {

  ami           = "ami-1dab2163"
  instance_type = "t3.micro"
}
