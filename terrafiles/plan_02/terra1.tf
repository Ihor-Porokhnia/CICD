provider "aws" {}

resource "aws_instance" "node" {
  count           = 3
  name            = "node.${count.index}"
  ami             = "ami-1dab2163"
  instance_type   = "t3.micro"
  key_name        = "main_key"
  subnet_id       = "${aws_subnet.main_subnet.id}"
  private_ip      = "172.31.0.1${count.index}"
  security_groups = ["${aws_security_group.allow_all.id}"]
}
/*
resource "aws_instance" "node1" {
  ami           = "ami-1dab2163"
  instance_type = "t3.micro"
  key_name      = "main_key"


  network_interface {
    network_interface_id = "${aws_network_interface.int1.id}"
    device_index         = 0
  }
}
resource "aws_instance" "node2" {
  ami           = "ami-1dab2163"
  instance_type = "t3.micro"
  key_name      = "main_key"


  network_interface {
    network_interface_id = "${aws_network_interface.int2.id}"
    device_index         = 0
  }
}
resource "aws_instance" "node3" {
  ami           = "ami-1dab2163"
  instance_type = "t3.micro"
  key_name      = "main_key"


  network_interface {
    network_interface_id = "${aws_network_interface.int3.id}"
    device_index         = 0
  }
}
*/
