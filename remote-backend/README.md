# Terraform Remote Backend

Configure S3 as remote backend for Terraform state management.

## Why Remote Backend?

- **Collaboration**: Multiple team members can work on the same infrastructure
- **State Locking**: Prevents concurrent modifications using DynamoDB
- **Security**: State file stored securely in S3
- **Versioning**: S3 versioning keeps history of state changes

## Structure

```
remote-backend/
├── create-backend/   # Creates S3 bucket and DynamoDB table for backend
├── proj1/            # Example project using remote backend
└── proj2/            # Another project using same backend
```

## Setup Steps

### 1. Create Backend Infrastructure

```bash
cd create-backend
terraform init
terraform apply
```

This creates:
- S3 bucket for state storage
- DynamoDB table for state locking

### 2. Configure Backend in Projects

In your project's `main.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "project-name/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

### 3. Initialize Backend

```bash
terraform init
```

Terraform will prompt to migrate existing state to S3.

## Benefits

- Centralized state management
- Team collaboration
- State locking prevents conflicts
- Automatic backup and versioning

## Cleanup

```bash
# First destroy all projects using the backend
cd proj1
terraform destroy

cd ../proj2
terraform destroy

# Then destroy backend infrastructure
cd ../create-backend
terraform destroy
```
