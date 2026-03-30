# Get AMI Name and Owner ID Using AWS CLI

This README shows how to get the AMI Name and Owner ID from an AMI ID using AWS CLI.

Example AMI used:

```bash
ami-0ec10929233384c7f
```

---

# Complete AMI Information

```bash
aws ec2 describe-images --image-ids ami-0ec10929233384c7f > ami-info.txt
```


---

# Get Only the Image Name

To extract only the AMI Name:

```bash
aws ec2 describe-images \
  --image-ids ami-0ec10929233384c7f \
  --query "Images[0].Name" \
  --output text
```

Example output:

```text
al2023-ami-2023.5.20250331.0-kernel-6.1-x86_64
```


---

# Get Only the Owner ID

To extract only the Owner ID:

```bash
aws ec2 describe-images \
  --image-ids ami-0ec10929233384c7f \
  --query "Images[0].OwnerId" \
  --output text
```

Example output:

```text
137112412989
```


---


