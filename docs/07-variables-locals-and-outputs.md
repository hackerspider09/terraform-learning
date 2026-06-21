# Variables, Locals, and Outputs

## Input Variables (`variable`)

Variables serve as parameters for a Terraform module, allowing users to customize behavior without editing the source code.

```hcl
variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro"
  sensitive   = false
}
```

### Variable Types
- **Primitive:** `string`, `number`, `bool`
- **Complex:** 
  - `list(type)`: Ordered collection (e.g., `["a", "b"]`)
  - `set(type)`: Unordered collection of unique values
  - `map(type)`: Key-value pairs (e.g., `{"us-east-1" = "ami-123", "us-west-2" = "ami-456"}`)
  - `object({ attr = type })`: A complex structure
  - `tuple([type, type])`: A list where elements have different specific types

### Variable Validation
You can enforce rules on variables to fail early.

```hcl
variable "ami_id" {
  type = string
  validation {
    condition     = length(var.ami_id) > 4 && substr(var.ami_id, 0, 4) == "ami-"
    error_message = "The ami_id value must be a valid AMI id, starting with \"ami-\"."
  }
}
```

### Setting Variable Values
Terraform loads variables in this order (highest precedence wins):
1. CLI flag: `-var="region=us-east-1"`
2. CLI flag file: `-var-file="custom.tfvars"`
3. Auto files: `*.auto.tfvars` or `*.auto.tfvars.json`
4. Default file: `terraform.tfvars`
5. Environment variables: `TF_VAR_region="us-east-1"`

---

## Local Values (`locals`)

A local value assigns a name to an expression. Use `locals` to avoid repeating the same logic or complex expressions across your code (DRY - Don't Repeat Yourself).

```hcl
locals {
  # Standardize naming conventions
  name_prefix = "${var.project}-${var.environment}"
  
  # Common tags merged with specific tags
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = merge(local.common_tags, { Name = "${local.name_prefix}-vpc" })
}
```

**Variables vs Locals:**
- Variables are values passed *into* your module from the outside.
- Locals are values calculated *inside* your module, completely hidden from the outside.

---

## Output Values (`output`)

Outputs are like return values for a module. They display information to the CLI after an `apply`, and they expose data for other modules to consume.

```hcl
output "web_server_ip" {
  description = "The public IP address of the web server"
  value       = aws_instance.web.public_ip
}

output "db_password" {
  value     = aws_db_instance.db.password
  sensitive = true # Hides the value in CLI output (but NOT in the state file!)
}
```
