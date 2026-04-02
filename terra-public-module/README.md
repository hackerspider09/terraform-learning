## Task day65


# Terraform: `for_each` vs `dynamic`

Terraform provides two common ways to repeat configuration:

* `for_each` → create multiple resources
* `dynamic` → create multiple nested blocks inside a single resource

---

# 1. Using `for_each`

Use `for_each` when you want Terraform to create multiple instances of a resource.

Example: create one security group ingress rule per port.

```hcl
variable "ingress_ports" {
  type    = list(number)
  default = [22, 80, 443]
}

resource "aws_vpc_security_group_ingress_rule" "allow_ingress" {
  for_each = toset([for p in var.ingress_ports : tostring(p)])

  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"

  from_port   = tonumber(each.value)
  to_port     = tonumber(each.value)
  ip_protocol = "tcp"
}
```

Terraform creates:

```text
aws_vpc_security_group_ingress_rule.allow_ingress["22"]
aws_vpc_security_group_ingress_rule.allow_ingress["80"]
aws_vpc_security_group_ingress_rule.allow_ingress["443"]
```

## Why `toset()` and `tostring()` are used

`for_each` only accepts:

* map(...)
* set(string)

If your variable is a list of numbers, convert it:

```hcl
toset([for p in var.ingress_ports : tostring(p)])
```

---

# 2. Using `dynamic`

Use `dynamic` when the resource itself contains repeatable nested blocks.

Example: older security group syntax with multiple `ingress {}` blocks inside one security group.

```hcl
resource "aws_security_group" "ec2_sg" {
  name = "ec2-security-group"

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

Terraform generates:

```hcl
ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

---

# 3. When to Use Which?

| Situation                                          | Use        |
| -------------------------------------------------- | ---------- |
| Need multiple resources                            | `for_each` |
| Need multiple nested blocks inside one resource    | `dynamic`  |
| Need one EC2 instance per name                     | `for_each` |
| Need many ingress blocks inside one security group | `dynamic`  |

Example:

```hcl
# Multiple EC2 instances
resource "aws_instance" "server" {
  for_each = toset(["web", "app", "db"])

  ami           = "ami-123456"
  instance_type = "t2.micro"

  tags = {
    Name = each.value
  }
}
```

This creates:

```text
aws_instance.server["web"]
aws_instance.server["app"]
aws_instance.server["db"]
```

---

# 4. `count` vs `for_each`

You may also see `count`.

```hcl
resource "aws_instance" "server" {
  count = 3
}
```

Terraform creates:

```text
aws_instance.server[0]
aws_instance.server[1]
aws_instance.server[2]
```

Prefer `for_each` when resources have unique names or values, because removing one item does not recreate the others.

Example:

```hcl
for_each = toset(["web", "app", "db"])
```

If `"app"` is removed, only that resource is destroyed.

With `count`, indexes shift and Terraform may recreate resources unexpectedly.

---

# 5. Rule of Thumb

```text
Need multiple resources?        -> for_each
Need multiple nested blocks?    -> dynamic
Need numbered resources only?   -> count
```

---

# 6. Common Mistake

This does NOT work:

```hcl
for_each = [22, 80, 443]
```

Because `for_each` cannot use a list of numbers directly.

Correct:

```hcl
for_each = toset(["22", "80", "443"])
```

or:

```hcl
for_each = {
  ssh  = 22
  http = 80
  https = 443
}
```

Then use:

```hcl
each.key
each.value
```

Example:

```hcl
for_each = {
  ssh  = 22
  http = 80
}

from_port = each.value
```

---

# Terraform `for_each`: Supported Data Types and Structures

`for_each` can iterate only over:

* `map(...)`
* `set(string)`

It cannot directly iterate over:

* `list(...)`
* `tuple(...)`
* `set(number)`
* `set(object)`

---

# Valid Data Structures

## 1. Map

```hcl id="sfg3lh"
for_each = {
  ssh  = 22
  http = 80
  https = 443
}
```

Inside the resource:

```hcl id="6m1q3o"
each.key   # ssh, http, https
each.value # 22, 80, 443
```

Example:

```hcl id="fd2x4q"
resource "aws_vpc_security_group_ingress_rule" "allow" {
  for_each = {
    ssh  = 22
    http = 80
    https = 443
  }

  from_port = each.value
  to_port   = each.value
}
```

---

## 2. Set of Strings

```hcl id="j4y7c2"
for_each = toset(["web", "app", "db"])
```

Inside the resource:

```hcl id="gwxv3l"
each.key   # "web", "app", "db"
each.value # same as key
```

Example:

```hcl id="ph3a8r"
resource "aws_instance" "server" {
  for_each = toset(["web", "app", "db"])

  tags = {
    Name = each.value
  }
}
```

Creates:

```text id="s0mb0p"
aws_instance.server["web"]
aws_instance.server["app"]
aws_instance.server["db"]
```

---

# Invalid Data Structures

These do NOT work directly:

```hcl id="o8mq0d"
for_each = [22, 80, 443]
```

Reason: this is a `list(number)`.

```hcl id="4a5gjx"
for_each = [ "web", "app", "db" ]
```

Reason: this is a `list(string)`, not a `set(string)`.

Convert it first:

```hcl id="0ph54e"
for_each = toset(["web", "app", "db"])
```

---

# Common Variable Types and How to Use Them

| Variable Type         | Works with `for_each`? | How                     |
| --------------------- | ---------------------- | ----------------------- |
| `map(string)`         | Yes                    | Directly                |
| `map(number)`         | Yes                    | Directly                |
| `map(object({...}))`  | Yes                    | Directly                |
| `set(string)`         | Yes                    | Directly                |
| `list(string)`        | No                     | Convert using `toset()` |
| `list(number)`        | No                     | Convert to string set   |
| `list(object({...}))` | No                     | Convert to map          |
| `tuple(...)`          | No                     | Convert first           |

---

# Examples

## list(string)

```hcl id="v4g8md"
variable "names" {
  type = list(string)
  default = ["web", "app", "db"]
}
```

Use:

```hcl id="o4h9za"
for_each = toset(var.names)
```

---

## list(number)

```hcl id="zv2h7l"
variable "ports" {
  type = list(number)
  default = [22, 80, 443]
}
```

Use:

```hcl id="6e0bvc"
for_each = toset([for p in var.ports : tostring(p)])
```

Then:

```hcl id="z8ybk6"
from_port = tonumber(each.value)
```

---

## list(object)

```hcl id="ly8f1s"
variable "instances" {
  type = list(object({
    name = string
    type = string
  }))
}
```

Example value:

```hcl id="x1e4gt"
instances = [
  {
    name = "web"
    type = "t2.micro"
  },
  {
    name = "app"
    type = "t2.small"
  }
]
```

`for_each` cannot use this directly.

Convert list → map:

```hcl id="s4wn0r"
for_each = {
  for instance in var.instances :
  instance.name => instance
}
```

Then:

```hcl id="wy3m9d"
each.key         # web, app
each.value.name  # web, app
each.value.type  # t2.micro, t2.small
```

Example:

```hcl id="e0pk3u"
resource "aws_instance" "server" {
  for_each = {
    for instance in var.instances :
    instance.name => instance
  }

  instance_type = each.value.type

  tags = {
    Name = each.value.name
  }
}
```

---

# Dynamic Block Iteration Types

`dynamic` is more flexible than `for_each`.

It can iterate over:

* list(...)
* map(...)
* set(...)
* tuple(...)

Example:

```hcl id="btzh9l"
dynamic "ingress" {
  for_each = [22, 80, 443]

  content {
    from_port = ingress.value
    to_port   = ingress.value
  }
}
```

This works because `dynamic` accepts lists directly.

---

# Summary Table

| Structure      | Example                           | `for_each` | `dynamic` |
| -------------- | --------------------------------- | ---------- | --------- |
| `map(string)`  | `{ web = "t2.micro" }`            | Yes        | Yes       |
| `map(object)`  | `{ web = { type = "t2.micro" } }` | Yes        | Yes       |
| `set(string)`  | `toset(["web","app"])`            | Yes        | Yes       |
| `list(string)` | `["web","app"]`                   | No         | Yes       |
| `list(number)` | `[22,80,443]`                     | No         | Yes       |
| `list(object)` | `[{ name = "web" }]`              | No         | Yes       |
| `tuple(...)`   | `["web", 1]`                      | No         | Yes       |
