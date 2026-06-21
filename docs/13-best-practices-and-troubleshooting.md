# Best Practices and Troubleshooting

## Project Structure Best Practices

A well-structured Terraform project makes it easier for teams to collaborate and scales better over time.

```
project-root/
├── .terraform.lock.hcl     # Lock file (Commit to Git)
├── backend.tf              # Backend configuration (S3, DynamoDB)
├── main.tf                 # Main resource definitions
├── variables.tf            # Input variables
├── outputs.tf              # Output definitions
├── providers.tf            # Provider configuration (AWS, Azure)
├── terraform.tfvars        # Default variable values (Do not commit if sensitive)
├── modules/                # Custom local child modules
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ec2/
└── scripts/                # bash or python scripts for user_data
```

## Security and Secret Management

Never hardcode secrets (passwords, API keys) in your Terraform `.tf` files.

**How to handle secrets:**
1. **Environment Variables:** Prefix the variable with `TF_VAR_`.
   ```bash
   export TF_VAR_db_password="SuperSecretPassword"
   ```
2. **AWS Systems Manager (SSM) Parameter Store / Secrets Manager:**
   Store the secret in AWS and use a `data` block to fetch it during `apply`.
   ```hcl
   data "aws_ssm_parameter" "db_password" {
     name = "/production/db/password"
     with_decryption = true
   }
   ```
3. **SOPS / HashiCorp Vault:** For enterprise environments, integrate external secrets management tools.

> [!CAUTION]
> Even if you don't hardcode the secret, **Terraform saves the value in plain text in the `terraform.tfstate` file**. You MUST use a Remote Backend (like S3) with encryption at rest and strict IAM access controls to protect the state file.

## CI/CD Integration

When running Terraform in a CI/CD pipeline (like GitHub Actions):
- **Init and Validate:** Run `terraform init` and `terraform validate` on every Pull Request.
- **Plan:** Run `terraform plan` and post the output as a comment on the PR so reviewers can see what will change.
- **Apply:** Only run `terraform apply -auto-approve` when code is merged into the `main` or `master` branch.
- **Security Scanning:** Use static analysis tools before applying:
  - `tfsec` or `trivy`: Scans for security misconfigurations (e.g., public S3 buckets).
  - `tflint`: Scans for cloud-provider-specific errors and enforces best practices.
  - `checkov`: Scans for security compliance.

## Troubleshooting and Debugging

### The `TF_LOG` Environment Variable

If Terraform is crashing, hanging, or behaving unexpectedly, you can enable detailed logging.

Set the `TF_LOG` environment variable to one of the following levels (in order of verbosity): `TRACE`, `DEBUG`, `INFO`, `WARN`, or `ERROR`.

```bash
export TF_LOG=DEBUG
terraform apply
```

To save the logs to a specific file instead of cluttering your terminal:
```bash
export TF_LOG_PATH="./terraform-debug.log"
```

### Common Errors

1. **Error acquiring the state lock:**
   - **Cause:** Someone else is running `apply`, or a previous run crashed.
   - **Fix:** Wait for the other run to finish. If it crashed, copy the Lock ID from the error message and run `terraform force-unlock <LOCK_ID>`.

2. **Cycle Error:**
   - **Cause:** Resource A depends on Resource B, but Resource B depends on Resource A.
   - **Fix:** Review your `depends_on` blocks and variable interpolations to break the circular dependency.

3. **Resource already managed by Terraform:**
   - **Cause:** You are trying to `import` a resource, but it already exists in the state file.
   - **Fix:** Check `terraform state list`. If it's there, you don't need to import it.

4. **Resource already exists (API Error):**
   - **Cause:** You wrote a resource block for an S3 bucket that someone already created manually in the AWS console. Terraform tries to create it and AWS throws a "BucketAlreadyExists" error.
   - **Fix:** Run `terraform import` to bring the existing bucket under Terraform's management.
