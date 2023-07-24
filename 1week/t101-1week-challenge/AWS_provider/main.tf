provider "aws" {
  default_tags {
    tags = {
      Environment = "Test"
      Name        = "Provider Tag"
    }
  }
}

resource "aws_vpc" "example" {
  cidr_block = "20.0.0.0/16"
  tags = {
    Environment = "Production"
  }
}

output "vpc_resource_level_tags" {
  value = aws_vpc.example.tags
}

output "vpc_all_tags" {
  value = aws_vpc.example.tags_all
}
