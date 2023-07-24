provider "aws" {
  region  = "ap-northeast-2"

  default_tags {

    tags = {

      Environment = "Challenge2"

      Name        = "Provider Tag"

    }

  }
}
# vpc.tf
resource "aws_vpc" "michanvpc" {
  cidr_block       = "10.20.0.0/16"

  tags = {
    Name = "t101-study"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "main-subnet" {
  vpc_id = aws_vpc.michanvpc.id
  cidr_block = "10.20.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  # e.g. ap-northeast-2a
}

#############
# sg.tf
resource "aws_security_group" "minchanSG" {
  vpc_id      = aws_vpc.michanvpc.id
  name        = "T101 SG"
  description = "T101 Study SG"
}

resource "aws_security_group_rule" "minchanSGRule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.minchanSG.id
}

resource "aws_security_group_rule" "minchanSGOutbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.minchanSG.id
}

#############
#ec2.tf

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
  vpc_security_group_ids      = ["${aws_security_group.minchanSG.id}"]
  subnet_id                   = aws_subnet.main-subnet.id

  user_data = <<-EOF
              #!/bin/bash
              wget https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-x86_64
              mv busybox-x86_64 busybox
              chmod +x busybox
              RZAZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone-id)
              IID=$(curl 169.254.169.254/latest/meta-data/instance-id)
              LIP=$(curl 169.254.169.254/latest/meta-data/local-ipv4)
              echo "<h1>RegionAz($RZAZ) : Instance ID($IID) : Private IP($LIP) : Web Server</h1>" > index.html
              nohup ./busybox httpd -f -p 80 &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "t101-myec2"
  }
}

output "myec2_public_ip" {
  value       = aws_instance.minchan-ec2.public_ip
  description = "The public IP of the Instance"
}