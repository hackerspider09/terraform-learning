# Installation and Authentication

To use Terraform effectively with cloud providers like AWS, you need to configure authentication so Terraform has permission to create and manage resources on your behalf.

## Installing Terraform

Terraform is distributed as a single binary.

1. **Linux/macOS:** You can install it via package managers (like `apt`, `brew`, or `yum`) or download the pre-compiled binary directly from the HashiCorp releases page.
2. **Windows:** Download the binary and add it to your system's `PATH`.

Verify the installation by running:
```bash
terraform version
```

---

## AWS CLI Configuration

The most common way to authenticate Terraform with AWS locally is by using the AWS CLI configuration. Terraform's AWS provider automatically searches for credentials in the standard AWS locations.

Configure your account on the CLI by running the `aws configure` command. It stores the credentials in `~/.aws/credentials` and configuration in `~/.aws/config`.

```bash
aws configure
```
You will be prompted for your Access Key ID, Secret Access Key, Default region name, and Default output format.

### Adding Another Profile

If you manage multiple AWS accounts, you can configure named profiles:

```bash
aws configure --profile username
```

### Using the `--profile` Flag

You can test if your profile works by using the `--profile` flag with AWS CLI commands:

```bash
aws s3 ls --profile username
```

### Verifying a Profile

To see exactly who you are authenticated as:

```bash
aws sts get-caller-identity --profile username
```

### Setting the Environment Variable

For the current terminal session, you can set the `AWS_PROFILE` environment variable. Terraform will automatically pick this up.

```bash
export AWS_PROFILE=user1
```

Once exported, you don't need to specify the `--profile` flag in AWS CLI or define the profile inside Terraform's provider block.

---

## Terraform AWS Provider Authentication

When you define the AWS provider in Terraform, you can explicitly tell it which profile to use:

```hcl
provider "aws" {
  region  = "us-east-1"
  profile = "username" # Matches the profile in ~/.aws/credentials
}
```

### Other Authentication Methods

While local profiles are great for development, production environments and CI/CD pipelines use more secure methods:

1. **Environment Variables:**
   Terraform respects `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables.
   ```bash
   export AWS_ACCESS_KEY_ID="anaccesskey"
   export AWS_SECRET_ACCESS_KEY="asecretkey"
   export AWS_REGION="us-west-2"
   ```

2. **IAM Roles (EC2 / ECS / EKS):**
   If Terraform is running on an AWS compute resource (like an EC2 instance), you can assign an IAM role to that resource. Terraform will automatically assume the role and use its temporary credentials. This is the most secure method as there are no long-lived keys.

3. **OIDC (OpenID Connect):**
   When running Terraform in GitHub Actions, GitLab CI, or other CI/CD platforms, OIDC allows the pipeline to request short-lived, temporary AWS credentials without storing any secret keys in the CI provider.

4. **AWS Vault / aws-sso:**
   Tools like `aws-vault` securely store IAM credentials in your operating system's keystore and generate temporary STS credentials for Terraform to use.
