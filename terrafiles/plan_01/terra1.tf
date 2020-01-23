provider "aws" {}


resource "aws_instance" "myUbuntu" {
  ami           = "ami-1dab2163"
  instance_type = "t3.micro"
  subnet_id       = "${aws_subnet.main_subnet.id}"
}

resource "aws_subnet" "main_subnet" {
  vpc_id                  = "vpc-04be235a7dda36c60"
  cidr_block              = "172.31.0.0/24"
  availability_zone       = "eu-north-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "internal subnet #1"
  }
}
