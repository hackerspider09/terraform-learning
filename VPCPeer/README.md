# VPC Peering with Terraform

Configure VPC peering connection between two VPCs.

## What is VPC Peering?

VPC peering allows you to connect two VPCs so that resources in both VPCs can communicate with each other using private IP addresses.

## Files

- `main.tf` - VPC peering configuration
- `provider.tf` - AWS provider configuration
- `variable.tf` - Variable definitions
- `terraform.tfvars` - Variable values
- `output.tf` - Output values

## Features

- Creates two VPCs
- Establishes peering connection
- Configures route tables for communication
- Security group rules for cross-VPC traffic

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Verification

After applying, you can test connectivity between instances in both VPCs using their private IPs.

## Cleanup

```bash
terraform destroy
```

## Important Notes

- VPCs must have non-overlapping CIDR blocks
- Route tables must be updated in both VPCs
- Security groups must allow traffic from peer VPC CIDR
