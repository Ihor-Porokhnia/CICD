provider "aws" {}

resource "aws_instance" "node" {
  count                  = "${var.instance_count}"
  ami                    = "ami-1dab2163"
  instance_type          = "t3.micro"
  key_name               = "main_key"
  subnet_id              = "${aws_subnet.main_subnet.id}"
  private_ip             = "172.31.0.1${count.index}"
  vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]

  tags = {
    Name = "node${count.index + 1}"
  }
}

variable "instance_count" {
  default = "1"
}


//-------------------------------------------------------------
/*
resource "aws_eip" "eip_manager" {
  instance = "${element(aws_instance.node.*.id, count.index)}"
  count    = "${var.instance_count}"
  vpc      = true

  tags = {
    Name = "eip--${count.index + 1}"
  }
}
*/
