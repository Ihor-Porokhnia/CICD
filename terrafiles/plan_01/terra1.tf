provider "aws" {
}
resource "aws_instance" "myubuntu" {
  ami           = "ami-1dab2163"
  instance_type = "t2.micro"

}
