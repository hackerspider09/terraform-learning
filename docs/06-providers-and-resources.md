# Providers and Resources

## The `terraform` Block

The `terraform` block configures Terraform's own behavior. This is where you specify the required versions of Terraform and the providers.

```hcl
terraform {
  required_version = ">= 1.5.0" # Terraform core version

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

## Providers

Providers are plugins that implement resource types. 

```hcl
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "Production"
    }
  }
}
```

### Provider Aliases (Multiple Regions/Accounts)

If you need to deploy resources to multiple AWS regions or accounts in the same project, you use aliases.

```hcl
# Default provider
provider "aws" {
  region = "us-east-1"
}

# Alternate provider
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

resource "aws_instance" "east_server" {
  ami = "ami-123"
  # Uses default provider automatically
}

resource "aws_instance" "west_server" {
  provider = aws.west # Explicitly use the alias
  ami      = "ami-456"
}
```

## Resources

Resource blocks are the most important element in Terraform. They describe an infrastructure object.

### Meta-Arguments

Meta-arguments change the behavior of resources. They are handled by Terraform Core, not the provider.

1. **`depends_on`**
   Terraform automatically infers dependencies. Use `depends_on` only when there is a hidden dependency that Terraform cannot see.
   ```hcl
   resource "aws_iam_role_policy" "example" { ... }

   resource "aws_instance" "example" {
     # Explicitly wait for the policy to attach before booting the EC2
     depends_on = [aws_iam_role_policy.example]
   }
   ```

2. **`count`**
   Creates multiple identical copies of a resource.
   ```hcl
   resource "aws_instance" "server" {
     count = 3
     ami   = "ami-123"
     tags = {
       Name = "Server-${count.index}" # count.index is 0, 1, 2
     }
   }
   ```

3. **`for_each`**
   Creates multiple resources from a map or a set of strings. Preferred over `count` because if you remove an item from the middle of the list, `for_each` won't recreate the subsequent resources.
   ```hcl
   resource "aws_iam_user" "users" {
     for_each = toset(["josh", "jane", "joe"])
     name     = each.value
   }
   ```

4. **`lifecycle`**
   Controls how Terraform creates, updates, and destroys the resource.
   ```hcl
   resource "aws_instance" "critical_server" {
     ami = "ami-123"

     lifecycle {
       create_before_destroy = true  # Zero downtime deployments (creates new before destroying old)
       prevent_destroy       = true  # Fails `terraform destroy` for this resource
       ignore_changes        = [tags] # Don't update if someone manually changes tags in AWS console
       replace_triggered_by  = [aws_security_group.example.id] # Recreate this EC2 if the SG changes
     }
   }
   ```
