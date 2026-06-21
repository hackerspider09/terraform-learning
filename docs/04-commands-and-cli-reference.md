# Commands and CLI Reference

Terraform's CLI interacts with your configuration files, the state file, and the cloud provider's API.

## Common Terraform Commands

- `terraform init`
  Initializes the Terraform working directory. This downloads required providers, initializes the backend, and downloads modules.
  **Common flags:**
  - `-upgrade` → Upgrade provider and module versions to the latest allowed by constraints.
  - `-backend=false` → Skip backend initialization.
  - `-reconfigure` → Reconfigure backend settings (ignores saved configuration).
  - `-migrate-state` → Migrate existing state to a new backend.

- `terraform validate`
  Validates Terraform configuration files for syntax and internal consistency without accessing remote services.
  **Common flags:**
  - `-json` → Output validation results in JSON format.
  - `-no-color` → Disable colored output.

- `terraform plan`
  Creates an execution plan showing what Terraform will add, change, or destroy by comparing your configuration to the current state.
  **Common flags:**
  - `-out=tfplan` → Save the plan to a file. Highly recommended for production to ensure exactly what was planned is applied.
  - `-var="key=value"` → Set a variable value.
  - `-var-file="terraform.tfvars"` → Load variables from a file.
  - `-destroy` → Create a plan to destroy infrastructure.
  - `-target=<resource>` → Plan changes for a specific resource only (use sparingly).
  - `-refresh=false` → Skip refreshing state before planning (faster, but potentially less accurate).

- `terraform apply`
  Applies the planned infrastructure changes.
  **Common flags:**
  - `-auto-approve` → Skip interactive approval prompt (used in CI/CD).
  - `tfplan` → Apply a previously saved plan file.
  - `-var="key=value"` → Set a variable value.
  - `-var-file="terraform.tfvars"` → Load variables from a file.
  - `-target=<resource>` → Apply changes to a specific resource only.
  - `-destroy` → Destroy infrastructure instead of creating/updating.

### Example Workflow
```bash
terraform init -upgrade
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

---

## Terraform Plan Symbols

`~`, `-`, `+` are used in the output of `terraform plan` and indicate the specific type of changes Terraform intends to make to the infrastructure.

### `+` (Create):
This indicates terraform will create a new resource that doesn't currently exist in the infrastructure.
![](../assets/create.png)

### `-` (Destroy):
This indicates terraform will destroy the resource as per the configuration or because it was removed from the code.
![](../assets/destroy.png)

### `~` (Update):
This indicates terraform will update the resource or try to modify the existing resource in-place, without recreating or deleting it.
![](../assets/updateinplace.png)

### `-/+` (Replace):
This indicates terraform must destroy the existing resource and create a new one to apply the change (often because an immutable attribute was modified).

---

## Useful Terraform State Commands

- `terraform show`
  Displays the current Terraform state or a saved plan in a human-readable format.
  ![](../assets/terra_show.png)

- `terraform state list`
  Lists all resources currently managed by Terraform in the state file.

- `terraform state show <resource_address>`
  Shows detailed information about a specific resource.
  - Example: `terraform state show aws_s3_bucket.my_bucket`
  - Example: `terraform state show aws_instance.my_server`
  ![](../assets/terra_list_and_stateshow.png)

### Example

```bash
terraform show
terraform state list
terraform state show aws_s3_bucket.my_bucket
terraform state show aws_instance.my_server
```

---

## Additional Helpful Commands

- `terraform fmt -recursive`
  Formats your `.tf` files into a canonical style (indentation, spacing). The `-recursive` flag formats files in subdirectories.
- `terraform console`
  Opens an interactive REPL console. You can type functions like `split(",", "a,b,c")` or check variable values against your state. Great for debugging expressions.
- `terraform refresh`
  Updates the local state file against real-world resources (implicitly done during `plan` and `apply`).
- `terraform force-unlock <LOCK_ID>`
  Manually removes a lock on the state. Only use this if a Terraform process crashed and left a stale lock in DynamoDB.
