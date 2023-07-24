provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "Challenge3"
      Name        = "Provider Tag"
    }
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

variable "subnet_cidr_block" {
  default = "10.0.0.0/24"
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = var.subnet_cidr_block
}

resource "aws_network_interface" example_ENI{
    count = 10
    subnet_id = aws_subnet.example.id
    private_ips = [cidrhost(var.subnet_cidr_block, count.index + 4)]
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux_2.id
  count         = 10
  instance_type = "t3.micro"
  

  tags = {
    Name = "terraform_instance_${count.index}"
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.example_ENI[count.index].id
  }
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}
