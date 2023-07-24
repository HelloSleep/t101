# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "myvpc"{
  cidr_block = "10.20.0.0/16"

  tags = {
    Name = "Challenge1-VPC"
  }

}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.20.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  # e.g. ap-northeast-2a
}

output  "aws_available_subnets" {
  value = data.aws_availability_zones.available.names
}
