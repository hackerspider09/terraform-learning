# State Management and Backends

## Terraform State File

Terraform uses a state file to keep track of the infrastructure it manages. This file is usually named `terraform.tfstate`.

The state file is essentially a database mapping your HCL configuration to real-world resources.

The state file contains:
- Resource IDs and names
- Current values of resource attributes
- Dependencies between resources
- Mapping between Terraform configuration and real infrastructure
- Outputs and metadata

Terraform reads this file during `plan` and `apply` to determine what has changed.

> [!CAUTION]
> Do not edit the state file manually. Incorrect changes can corrupt the state and cause Terraform to create, update, or delete the wrong resources.

> [!WARNING]
> Do not commit the state file (`terraform.tfstate` or `terraform.tfstate.backup`) to Git because it may contain sensitive information such as passwords, access keys, secrets, and infrastructure details in plain text.

> **Note:** "State file" is the general term. `terraform.tfstate` is the default filename Terraform uses for that file locally.

## Remote Backends

By default, Terraform stores state locally in a file named `terraform.tfstate`. In a team environment, this is problematic:
- Other team members cannot access your local file.
- Multiple people running Terraform at the same time could corrupt the state.
- Sensitive data is stored in plain text on your hard drive.

To solve this, Terraform uses **Remote Backends**. A backend defines where state is stored and how operations are performed.

### S3 Backend with DynamoDB Locking

The most common backend for AWS users is an S3 bucket combined with a DynamoDB table.
- **S3 Bucket:** Stores the state file securely (supports encryption at rest and versioning).
- **DynamoDB Table:** Provides state locking. If User A is running `terraform apply`, DynamoDB places a lock on the state file. If User B tries to run Terraform, it will fail until User A's run completes.

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
```

*Note: You cannot use variables inside the `backend` block. It must be hardcoded or passed via CLI args/backend config files.*

## Terraform Lock File

Terraform also creates a lock file named `.terraform.lock.hcl` upon running `terraform init`.

The lock file stores:
- Exact versions of providers being used
- Checksums (SHA256 hashes) for provider verification

This ensures everyone using the project (and your CI/CD pipelines) installs the exact same provider versions, preventing "works on my machine" bugs.

> [!IMPORTANT]
> Unlike the state file, the `.terraform.lock.hcl` file **should be committed to Git**.

## Advanced State Management Commands

Sometimes Terraform's state gets out of sync with reality, or you need to refactor your code without destroying and recreating resources.

- `terraform state mv`: Move an item in the state. Useful if you rename a resource block in your code but don't want to destroy the actual resource.
  ```bash
  terraform state mv aws_instance.old_name aws_instance.new_name
  ```
- `terraform state rm`: Remove an item from the state. Terraform will stop managing the resource, but it will *not* be destroyed in the cloud.
  ```bash
  terraform state rm aws_instance.my_server
  ```
- `terraform taint <resource>` (Deprecated, use `-replace`): Marks a resource to be destroyed and recreated on the next apply.
  ```bash
  terraform apply -replace="aws_instance.my_server"
  ```
- `terraform untaint <resource>`: Removes the taint from a resource.
