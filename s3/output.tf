output "s3-bucket-domain" {
  description = "Bucket domain name"
  value = aws_s3_bucket.terra_s3.bucket_domain_name
}