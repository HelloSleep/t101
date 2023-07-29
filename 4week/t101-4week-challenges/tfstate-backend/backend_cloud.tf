provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "mys3bucket" {
  bucket = "minchan-t101study-tfstate"
}

# Enable versioning so you can see the full revision history of your state files
resource "aws_s3_bucket_versioning" "mys3bucket_versioning" {
  bucket = aws_s3_bucket.mys3bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.mys3bucket.arn
  description = "The ARN of the S3 bucket"
}



resource "aws_dynamodb_table" "mydynamodbtable" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}



output "dynamodb_table_name" {
  value       = aws_dynamodb_table.mydynamodbtable.name
  description = "The name of the DynamoDB table"
}
