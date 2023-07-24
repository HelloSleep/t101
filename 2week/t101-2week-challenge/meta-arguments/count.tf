locals{
    ami = "ami-0ea4d4b8dc1e46212"
    instance_type = "t2.micro"
}

variable "instance_count" {
  description = "Number of instances to create"
  default     = 3
}

resource "aws_instance" "example_count" {
  count = var.instance_count

  ami           = local.ami
  instance_type = local.instance_type

  tags = {
    Name = "example-instance-${count.index}"
  }
}
