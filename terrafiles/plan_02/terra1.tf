provider "aws" {}

resource "aws_instance" "node" {
  count           = 3
  ami             = "ami-1dab2163"
  instance_type   = "t3.micro"
  key_name        = "main_key"
  subnet_id       = "${aws_subnet.main_subnet.id}"
  private_ip      = "172.31.0.1${count.index}"
  security_groups = ["${aws_security_group.allow_all.id}"]

  tags = {
    Name = "node.${count.index}"
  }
}
