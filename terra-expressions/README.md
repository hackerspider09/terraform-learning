# Terraform Expressions and Functions

Examples of Terraform expressions, variables, loops, conditions, and built-in functions.

## Files

- `variables.tf` - Variable definitions
- `commonVar.tf` - Common variables
- `list.tf` - List operations
- `map.tf` - Map operations
- `loops.tf` - Loop examples
- `map_loop.tf` - Looping over maps
- `condition.tf` - Conditional expressions
- `loop_with_condition.tf` - Combining loops and conditions
- `string_functions.tf` - String manipulation functions

## Concepts Covered

### Variables
- Variable types (string, number, list, map, object)
- Default values
- Variable validation

### Loops
- `for` expressions
- `for_each` meta-argument
- `count` meta-argument

### Conditions
- Ternary operator: `condition ? true_val : false_val`
- Conditional resource creation

### String Functions
- `upper()`, `lower()`
- `substr()`, `replace()`
- `join()`, `split()`
- `format()`, `trim()`

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Cleanup

```bash
terraform destroy
```
