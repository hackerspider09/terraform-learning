# Terraform Scripts and Reference

This repository serves as a practical reference for learning and utilizing HashiCorp Terraform in AWS environments. It contains structured notes and runnable infrastructure scripts.

---

## 📖 Documentation Library

The `docs/` directory contains a modular guide covering foundational IaC concepts, state management, and lifecycle rules. It is designed to be used as a quick reference during daily work.

### Core Concepts & Setup
- [01. Introduction and Core Concepts](./docs/01-introduction-and-core-concepts.md) - IaC principles, architecture, and workflow.
- [02. Installation and Authentication](./docs/02-installation-and-authentication.md) - AWS CLI config, profiles, IAM roles, and OIDC.
- [03. State Management and Backends](./docs/03-state-management-and-backends.md) - The state file, lock file, and S3/DynamoDB remote backends.
- [04. Commands and CLI Reference](./docs/04-commands-and-cli-reference.md) - Common commands, state commands, and `plan` symbols (`+`, `-`, `~`).

### Writing Terraform (HCL)
- [05. HCL Syntax and Structure](./docs/05-hcl-syntax-and-structure.md) - Blocks, identifiers, comments, and `path` references.
- [06. Providers and Resources](./docs/06-providers-and-resources.md) - Aliases, meta-arguments (`depends_on`, `count`, `for_each`), and `lifecycle`.
- [07. Variables, Locals, and Outputs](./docs/07-variables-locals-and-outputs.md) - Variable validation, DRY code with locals, and sensitive outputs.
- [08. Data Sources and Imports](./docs/08-data-sources-and-imports.md) - Reading existing infra and declarative `import` blocks.
- [09. Expressions and Loops](./docs/09-expressions-and-loops.md) - Conditionals, splat `[*]`, `for` loops, and `dynamic` blocks.
- [10. Functions and String Operations](./docs/10-functions-and-operations.md) - Using `file()`, `templatefile()`, string/list manipulations, and network functions.

### Architecture & Operations
- [11. Modules and Workspaces](./docs/11-modules-and-workspaces.md) - Structuring child modules, public registries, and environment workspaces.
- [12. Utility Providers and Provisioners](./docs/12-utility-providers-and-provisioners.md) - Using `random`, `tls`, `local`, `null`, and remote-exec provisioners.
- [13. Best Practices and Troubleshooting](./docs/13-best-practices-and-troubleshooting.md) - Directory structures, CI/CD, secret management, and `TF_LOG` debugging.

---

## 🛠️ Practical Implementations & Scripts

These directories contain working Terraform configurations demonstrating the concepts covered in the documentation library.

### Basic Infrastructure
- **[S3 Bucket](./s3/)** - Basic S3 bucket creation and configuration.
- **[EC2 Instance](./default_ec2/)** - Default, single EC2 setup.
- **[EC2 with VPC](./ec2_scratch/)** - EC2 deployed within a custom VPC, demonstrating AMI queries and dependency graphs.
- **[VPC Peering](./VPCPeer/)** - Setting up VPC peering connections.

### Advanced Implementations
- **[Terraform Modules](./terra-modules/)** - Creating, structuring, and consuming local child modules.
- **[Public Modules](./terra-public-module/)** - Using modules from the public Terraform Registry, comparing `for_each` vs `dynamic` blocks.
- **[Data Sources](./terra-data/)** - Reading existing infrastructure using `data` blocks.
- **[Import Resources](./terra-import/)** - Demonstrating how to bring existing AWS resources into Terraform management.
- **[Expressions & Functions](./terra-expressions/)** - Practical usage of variables, loops, conditions, and string functions.
- **[Remote Backend](./remote-backend/)** - S3 and DynamoDB remote backend configuration for state locking and management.
- **[AWS EKS](./aws_eks_module/)** - EKS Kubernetes cluster provisioning using official modules.
