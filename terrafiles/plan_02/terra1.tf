provider "aws" {}


resource "aws_instance" "nodes" {

  ami           = "ami-1dab2163"
  instance_type = "t3.micro"

  network_interface {
    network_interface_id = "${aws_network_interface.int1.id}"
    device_index         = 0
  }

}
