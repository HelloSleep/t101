resource "aws_instance" "mysrv1" {
  ami           = "ami-0ea4d4b8dc1e46212"
  instance_type = "t2.micro"
  tags = {
    Name = "t101-week4"
  }
}