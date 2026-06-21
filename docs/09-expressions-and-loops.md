# Expressions and Loops

HCL allows you to use complex logic within your configuration, making your infrastructure code dynamic.

## Conditional Expressions

A conditional expression uses a boolean to select one of two values (similar to the ternary operator in C/JS).

Syntax: `condition ? true_val : false_val`

```hcl
variable "is_production" {
  type = bool
}

resource "aws_instance" "web" {
  ami           = "ami-12345"
  # If is_production is true, use m5.large, else use t2.micro
  instance_type = var.is_production ? "m5.large" : "t2.micro"
}
```

## Splat Expressions `[*]`

A splat expression provides a concise way to express a common operation: extracting the same attribute from a list of objects.

```hcl
resource "aws_instance" "web" {
  count = 3
  # ...
}

output "private_ips" {
  # Instead of writing a complex for loop, get the private_ip from all instances:
  value = aws_instance.web[*].private_ip
}
```

---

## Looping Constructs

Terraform doesn't have traditional `while` or `for` statement blocks like Python. Instead, it handles iteration functionally.

### `for` Expressions

A `for` expression transforms one complex type (list/map) into another complex type.

**List to List:**
```hcl
locals {
  words = ["foo", "bar", "baz"]
  upper_words = [for w in local.words : upper(w)]
  # Result: ["FOO", "BAR", "BAZ"]
}
```

**List to Map:**
```hcl
locals {
  servers = ["web", "db"]
  # Convert list into a map where the key is the server name and value is the instance size
  server_map = { for s in local.servers : s => "t2.micro" }
  # Result: { "web" = "t2.micro", "db" = "t2.micro" }
}
```

**Map to Map:**
```hcl
locals {
  tags = { project = "api", env = "dev" }
  upper_tags = { for k, v in local.tags : upper(k) => upper(v) }
}
```

### `dynamic` Blocks

Sometimes you need to create nested blocks inside a resource dynamically based on a variable. `count` and `for_each` only work at the resource-level, not inside them. 

Use `dynamic` blocks to loop over a list and create nested blocks.

```hcl
variable "ingress_ports" {
  type    = list(number)
  default = [80, 443, 8080]
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow inbound traffic"

  # Iterates over ingress_ports to create multiple "ingress { ... }" blocks
  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```
In the above example, `ingress.value` refers to the current item in the `for_each` loop.
