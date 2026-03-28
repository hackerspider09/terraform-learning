# S3
resource "aws_s3_bucket" "terra_s3" {
  bucket = "terra-s3-bucket-28-2-26"


  tags = {
    Name = "terra-s3"
  }
}

# enable versioning
resource "aws_s3_bucket_versioning" "vers_bucket" {
  bucket = aws_s3_bucket.terra_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}