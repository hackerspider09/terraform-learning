# S3 for statefile

resource "aws_s3_bucket" "backend_s3" {
  bucket = "terra-s3-1-4-2026"

  tags = {
    Name        = "Terra-s3"
    Environment = "Dev"
  }
}


# Dynamo db
resource "aws_dynamodb_table" "backend_dyno" {
  name           = "terra-dyno"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
