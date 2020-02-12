resource "aws_key_pair" "main_key" {
  key_name   = "main_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCBFCNX/pZO9DfdFctvjgCEfC4rxcrYNxffcXWZiSWgUpKJM5EPx4Us6g4nlZ6doPI8Sxtt/bh78kHG/E1zvE86fgbOCkIxsG2RZHdDVSzEO9Wdnfq+IYy76wbkqckLm2gSkj4KJvCLqQ0WlqS+4DZcA5xjOxjzRNkQt1IfOEsNJB2+eDRl5Zu7G+nPgl4LMHFp+WLhAwdzhDFeYYIRBa/NNvL6aZGNj7WrqBQoxcIr7CBMzBG+5MQ9El1dUBZ35G7ziCoLnFSRXCf4HXYY+2MSL8x/ZlUefZCcZdXGrQSU/EYRxBwIw2uwnQJiEvYHuU8OTHnnLYh7hYMYIl1SEo9 main_key"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all traffic"
  //vpc_id      = "${aws_default_vpc.main_vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
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

resource "aws_subnet" "main_subnet" {
  vpc_id                  = "vpc-04be235a7dda36c60"
  cidr_block              = "172.31.0.0/24"
  availability_zone       = "eu-north-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "internal subnet #1"
  }
}


//--------------------------------------------------------
/*
resource "aws_default_vpc" "main_vpc" {

  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "default vpc"
  }
}
*/
