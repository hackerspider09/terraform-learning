# Data Sources and Imports

## Data Sources (`data`)

Data sources allow Terraform to read data that is defined outside of Terraform, or defined by another separate Terraform configuration. They are read-only operations.

If you have an existing VPC that was created manually, you can use a data source to fetch its ID to deploy an EC2 instance into it.

```hcl
# Read an existing AWS VPC by its Name tag
data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["Production-VPC"]
  }
}

# Fetch the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = tolist(data.aws_subnet_ids.example.ids)[0]
}
```

---

## Importing Infrastructure

If infrastructure was created manually (e.g., clicking around the AWS console), you can bring it under Terraform management.

There are two ways to do this:

### 1. The `terraform import` command (Legacy approach)

You write the empty resource block:
```hcl
resource "aws_instance" "my_server" {
  # leave empty initially
}
```

Then run the command using the AWS Resource ID:
```bash
terraform import aws_instance.my_server i-1234567890abcdef0
```

Terraform pulls the resource from AWS and places it into the `terraform.tfstate`. 
However, your code is still empty. You must then run `terraform plan`, see the differences, and manually write the HCL to match the state exactly so that the next `plan` shows `0 changes`.

### 2. The `import` block (Terraform 1.5+ Modern approach)

Terraform 1.5 introduced declarative imports.

Write an import block specifying the ID and where you want it mapped:
```hcl
import {
  to = aws_instance.my_server
  id = "i-1234567890abcdef0"
}
```

You can then let Terraform generate the HCL code for you:
```bash
terraform plan -generate-config-out=generated.tf
```

Terraform will create `generated.tf` with the fully populated `resource "aws_instance" "my_server"` block. You can review it, tweak it, and move it into your main `.tf` files.
