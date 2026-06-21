# HCL Syntax and Structure

Terraform uses HashiCorp Configuration Language (HCL). It is designed to be machine-friendly but also highly readable for humans.

## Basic Syntax

HCL consists of **Blocks**, **Arguments**, and **Expressions**.

```hcl
<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>" {
  # Block body
  <IDENTIFIER> = <EXPRESSION> # Argument
}
```

### Example
```hcl
resource "aws_instance" "web" {
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"
}
```
- **Block Type:** `resource`
- **Block Labels:** `"aws_instance"` (resource type) and `"web"` (local name)
- **Identifier:** `ami`
- **Expression:** `"ami-a1b2c3d4"`

## Comments

HCL supports three types of comments:

```hcl
# This is a single-line comment (preferred)
// This is also a single-line comment

/* 
This is a 
multi-line comment 
*/
```

## Identifiers and References

Identifiers can contain letters, digits, underscores (`_`), and hyphens (`-`). The first character must not be a digit.

You reference other blocks by stringing together their labels:
- Resource reference: `<RESOURCE_TYPE>.<LOCAL_NAME>.<ATTRIBUTE>` (e.g., `aws_instance.web.id`)
- Variable reference: `var.<NAME>` (e.g., `var.region`)
- Local value reference: `local.<NAME>` (e.g., `local.common_tags`)
- Module output reference: `module.<MODULE_NAME>.<OUTPUT_NAME>`
- Data source reference: `data.<DATA_TYPE>.<LOCAL_NAME>.<ATTRIBUTE>`

## Path References

Terraform provides several built-in path references that are extremely useful when dealing with local files (like templates, lambda zip files, or ssh keys).

- `path.module` - The filesystem path of the module where the expression is placed. **(Used 90% of the time)**
- `path.root` - The filesystem path of the root module of the configuration.
- `path.cwd` - The filesystem path of the original working directory from where you ran Terraform.

### Why `path.module` is critical

If you use a relative path like `"./script.sh"` inside a module, and then call that module from another directory, Terraform looks for `./script.sh` in the *calling* directory, not the module directory. 

Always use `path.module` for reliable file referencing:
```hcl
data "template_file" "init" {
  template = file("${path.module}/scripts/init.sh")
}
```
