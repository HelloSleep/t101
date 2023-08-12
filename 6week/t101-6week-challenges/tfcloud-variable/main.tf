provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 LTS AMI ID
  instance_type = "t2.micro"

  tags = {
    Name = "MyInstance"
  }
}
