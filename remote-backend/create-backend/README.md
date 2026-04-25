# Create Backend Infrastructure

Creates S3 bucket and DynamoDB table for Terraform remote backend.

## Resources Created

- S3 bucket for state storage (with versioning and encryption)
- DynamoDB table for state locking

## Usage

```bash
terraform init
terraform apply
```

## Note

Run this first before using remote backend in other projects.
