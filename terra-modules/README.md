# Terraform Modules

Learn how to create and use local Terraform modules.

## What are Modules?

Modules are containers for multiple resources that are used together. They help organize and reuse Terraform code.

## Structure

```
terra-modules/
├── main.tf           # Root module that calls child modules
└── modules/
    └── createFile/   # Child module for file creation
```

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Benefits

- Code reusability
- Better organization
- Easier maintenance
- Encapsulation of logic

## Cleanup

```bash
terraform destroy
```
