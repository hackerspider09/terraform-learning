# Default EC2 Instance

Basic EC2 instance creation using default VPC and security group.

## Files

- `main.tf` - EC2 instance resource definition
- `providers.tf` - AWS provider configuration
- `output.tf` - Output values for instance information

## Features

- Uses default VPC
- Uses default security group
- Basic EC2 instance configuration

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Cleanup

```bash
terraform destroy
```
