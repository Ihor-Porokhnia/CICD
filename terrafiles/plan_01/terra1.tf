provider "aws" {
}
resource "aws_instance" "my_ubuntu" {
  ami           = "ami-1dab2163"
  instance_type = "t2.micro"

}
