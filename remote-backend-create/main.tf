# S3 for statefile

resource "aws_s3_bucket" "backend_s3" {
  bucket = "terra-s3"

  tags = {
    Name        = "Terra-s3"
    Environment = "Dev"
  }
}


# Dynamo db
resource "aws_dynamodb_table" "backend_dyno" {
  name           = "terra-dyno"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }
}
