resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all traffic"
  vpc_id      = "${aws_vpc.main_vps.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }
}

resource "aws_vpc" "main_vps" {
  cidr_block = "172.31.0.0/16"
  tags = {
    Name = "default vps"
  }
}

resource "aws_subnet" "main_subnet" {
  vpc_id            = "${aws_vpc.main_vps.id}"
  cidr_block        = "172.31.0.0/24"
  availability_zone = "eu-north-1c"

  tags = {
    Name = "internal subnet #1"
  }
}

resource "aws_network_interface" "int1" {
  subnet_id   = "${aws_subnet.main_subnet.id}"
  private_ips = ["172.31.0.10"]
  tags = {
    Name = "node1 int"
  }
}
resource "aws_network_interface" "int2" {
  subnet_id   = "${aws_subnet.main_subnet.id}"
  private_ips = ["172.31.0.11"]
  tags = {
    Name = "node2 int"
  }
}
resource "aws_network_interface" "int3" {
  subnet_id   = "${aws_subnet.main_subnet.id}"
  private_ips = ["172.31.0.12"]
  tags = {
    Name = "node3 int"
  }
}
