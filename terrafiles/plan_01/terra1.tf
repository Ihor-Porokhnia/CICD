provider "aws" {
}
resource "aws_instance" "myubuntu" {
  ami           = "ami-0cc0a36f626a4fdf5"
  instance_type = "t2.micro"

}
