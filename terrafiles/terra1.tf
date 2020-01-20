provider "AWS" {
  access_key = "AKIAZGWYTGJHOJ2FL7OK"
  secret_key = "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"
  region = "eu-central-1"

}
resource "aws_instance" "my_ubuntu" {
  ami = "ami-0cc0a36f626a4fdf5"
  instance_type = "t2.micro"

}
