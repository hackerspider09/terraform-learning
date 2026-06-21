# Modules and Workspaces

## Terraform Modules

A module is a container for multiple resources that are used together. Modules allow you to create reusable abstractions, packaging complex infrastructure into simple, configurable components.

Every Terraform configuration has at least one module, known as its **root module**. Modules called by the root module are **child modules**.

### Calling a Child Module

To use a module, use a `module` block. The `source` argument is mandatory and tells Terraform where the module code lives.

**1. Local Modules:**
Referenced using relative paths.
```hcl
module "vpc" {
  source = "../modules/vpc"
  
  # Variables expected by the module
  vpc_cidr = "10.0.0.0/16"
  project  = "ecommerce"
}
```

**2. Terraform Registry Modules (Public):**
You can use official, community-maintained modules.
```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"
  
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}
```

**3. Git Repository Modules:**
```hcl
module "vpc" {
  source = "git::https://github.com/my-org/terraform-aws-vpc.git?ref=v1.2.0"
}
```

### Module Structure

A good module should be self-contained and follow a standard structure:
```
vpc-module/
├── main.tf      # The primary resource configuration
├── variables.tf # Input variables (the module's "arguments")
├── outputs.tf   # What the module returns (the module's "return values")
└── README.md    # Documentation
```

### Using Module Outputs

If a module defines an `output "vpc_id"`, you can reference it in the parent configuration using `module.<MODULE_NAME>.<OUTPUT_NAME>`.

```hcl
resource "aws_instance" "web" {
  ami       = "ami-123"
  subnet_id = module.vpc.public_subnets[0] # referencing the public registry module output
}
```

---

## Terraform Workspaces

Workspaces allow you to manage multiple states associated with a single configuration directory.

This is useful if you want to deploy exactly the same infrastructure code to `dev`, `staging`, and `prod` without duplicating directories.

### Workspace Commands

- `terraform workspace list`
- `terraform workspace new dev`
- `terraform workspace select dev`
- `terraform workspace show`

### Using `terraform.workspace`

You can access the current workspace name in your code using the `terraform.workspace` variable to conditionally change names or sizes.

```hcl
resource "aws_instance" "web" {
  ami = "ami-123"
  
  # If we are in the prod workspace, use m5.large, else t2.micro
  instance_type = terraform.workspace == "prod" ? "m5.large" : "t2.micro"

  tags = {
    Name = "web-server-${terraform.workspace}"
  }
}
```

> [!WARNING]
> While CLI Workspaces are useful for quick testing, HashiCorp officially recommends using **separate directories (one per environment)** or using **Terraform Cloud Workspaces** (which map 1:1 to VCS branches) for production scale, as relying on CLI workspaces makes it easy to accidentally apply to the wrong environment.
