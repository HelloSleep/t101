# locals{
#     ami = "ami-0ea4d4b8dc1e46212"
#     instance_type = "t2.micro"
# }

variable "instances" {
  description = "Map of instances to create"
  default = {
    "instance-1" = "tag1"
    "instance-2" = "tag2"
    "instance-3" = "tag3"
  }
}

resource "aws_instance" "example_for_each" {
  for_each = var.instances

  ami           = local.ami
  instance_type = local.instance_type

  tags = {
    Name = each.key
    Tag  = each.value
  }
}
