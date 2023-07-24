locals{
    ami = "ami-0ea4d4b8dc1e46212"
    instance_type = "t2.micro"
}

resource "aws_instance" "server1" {
  ami           = local.ami
  instance_type = local.instance_type


}

resource "aws_instance" "server2" {
  ami           = local.ami
  instance_type = local.instance_type


}
