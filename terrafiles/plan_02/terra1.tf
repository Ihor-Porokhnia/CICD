provider "aws" {}


resource "aws_instance" "node1" {
  ami           = "ami-1dab2163"
  instance_type = "t3.micro"
  network_interface {
    network_interface_id = "${aws_network_interface.int1.id}"
    device_index         = 0
  }
}
resource "aws_instance" "node2" {
  ami           = "ami-1dab2163"
  instance_type = "t3.micro"
  network_interface {
    network_interface_id = "${aws_network_interface.int2.id}"
    device_index         = 0
  }
}
resource "aws_instance" "node3" {
  ami           = "ami-1dab2163"
  instance_type = "t3.micro"
  network_interface {
    network_interface_id = "${aws_network_interface.int3.id}"
    device_index         = 0
  }
}
