provider "aws" {}


resource "aws_instance" "my_Ubuntu" {
  count         = 3
  ami           = "ami-1dab2163"
  instance_type = "t3.micro"
}