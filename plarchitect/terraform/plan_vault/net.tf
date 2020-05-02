resource "aws_vpc" "main" {
  cidr_block = var.cidr_vpc
}
resource "aws_subnet" "external_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_ext_sub
  availability_zone       = var.AZ
  map_public_ip_on_launch = true

  tags = {
    Name = "external subnet"
  }
}

variable "AZ" {
  type    = string  
}
variable "cidr_vpc" {
  type    = string
  default = "172.72.0.0/16"  
}
variable "cidr_ext_sub" {
  type    = string
  default = "172.72.0.0/24"  
}