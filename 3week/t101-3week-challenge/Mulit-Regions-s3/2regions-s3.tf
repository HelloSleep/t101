provider "aws" {
  region = "ap-northeast-2"
}

provider "aws" {
  alias = "tokyo"
  region = "ap-northeast-1"
}

resource "aws_s3_bucket" "tokyo-s3" {
    provider      = aws.tokyo
    bucket = "my-tokyo-bucket-6490646"
  
}

resource "aws_s3_bucket" "seoul-s3" {
  
  bucket = "my-seoul-bucket-90894964"
}