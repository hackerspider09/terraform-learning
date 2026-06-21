# Introduction and Core Concepts

## What is Terraform?

Terraform is an open-source Infrastructure as Code (IaC) tool created by HashiCorp. It allows you to define, provision, and manage cloud and on-premises infrastructure using a high-level configuration language called HashiCorp Configuration Language (HCL).

Terraform can manage low-level components like compute instances, storage, and networking, as well as high-level components like DNS entries, SaaS features, and application configurations.

## Infrastructure as Code (IaC) Principles

IaC is the process of managing and provisioning computing infrastructure through machine-readable definition files, rather than physical hardware configuration or interactive configuration tools.

- **Reproducibility:** Infrastructure can be spun up in different environments (dev, staging, prod) with the exact same configuration.
- **Version Control:** Configuration files can be versioned in Git, allowing teams to track changes, review code, and rollback if necessary.
- **Automation:** Eliminates manual clicks in cloud console GUIs, reducing human error.
- **Documentation:** The code itself serves as the ultimate, up-to-date documentation of your infrastructure.

## Declarative vs. Imperative

Terraform is a **declarative** tool. 

- **Declarative (Terraform):** You describe the *desired end-state* of your infrastructure. You tell Terraform "I want 3 EC2 instances and 1 S3 bucket", and Terraform figures out how to get there. It calculates the difference between the current state and the desired state, and executes the minimum necessary steps.
- **Imperative (e.g., AWS CLI scripts):** You define the *exact steps* to reach the end-state. You write scripts that say "Create instance 1, then create instance 2, then create instance 3".

## Terraform Architecture

Terraform is logically split into two main parts:

### 1. Terraform Core
Terraform Core is a statically-compiled binary written in Go. It handles:
- Reading and interpolating configuration files and modules.
- Managing the state file.
- Constructing the Resource Graph (dependency graph).
- Executing plans and communicating with plugins over RPC.

### 2. Terraform Plugins (Providers & Provisioners)
Terraform Core uses a plugin-based architecture. 
- **Providers:** Plugins that interact with cloud platforms (AWS, Azure, GCP) or other services (GitHub, Datadog) via their APIs. When you declare `provider "aws"`, Terraform Core downloads the AWS provider plugin.
- **Provisioners:** Plugins used to execute scripts on a local or remote machine as part of resource creation or destruction (e.g., running a bash script on a newly booted EC2 instance).

## The Terraform Workflow

The standard workflow for using Terraform consists of three main steps:

1. **Write:** Author infrastructure as code in `.tf` files.
2. **Plan:** Run `terraform plan` to preview the changes Terraform will make to match your configuration.
3. **Apply:** Run `terraform apply` to provision the infrastructure. Terraform interacts with the cloud APIs to create the resources.
