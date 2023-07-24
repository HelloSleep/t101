variable "web-tag" {
  type        = string
  description = "The EC2 tag name"

  validation {
    condition     = can(regex("ec2", var.web-tag))
    error_message = "The name value must include 'ec2'."
  }
}


provider "aws" {
  region  = "ap-northeast-2"

  default_tags {

    tags = {

      Environment = "Challenge2"

      Name        = "Provider Tag"

    }

  }
}

data "aws_ami" "minchan_amazonlinux2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "minchan-ec2" {
 ami                         = data.aws_ami.minchan_amazonlinux2.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  # vpc_id = aws_vpc.michanvpc.id

  user_data_replace_on_change = true

  tags = {
    Name = var.web-tag
  }
}