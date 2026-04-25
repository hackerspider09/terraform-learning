# AWS EKS Cluster with Terraform

Provision an AWS EKS (Elastic Kubernetes Service) cluster using the official AWS EKS Terraform module.

## Documentation

- Module: https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

## Files

- `eks.tf` - EKS cluster configuration
- `vpc.tf` - VPC configuration for EKS
- `terraform.tf` - Terraform and provider versions
- `variables.tf` - Variable definitions
- `terraform.tfvars` - Variable values
- `locals.tf` - Local values
- `outputs.tf` - Output values
- `nginx-deployment.yaml` - Sample Kubernetes deployment

## Usage

### 1. Provision EKS Cluster

```bash
terraform init
terraform plan
terraform apply
```

### 2. Configure kubectl

```bash
aws eks update-kubeconfig --region us-east-1 --name Terra-EKS
```

### 3. Deploy Sample Application

```bash
kubectl apply -f nginx-deployment.yaml
```

### 4. Verify Deployment

```bash
kubectl get svc -o wide
```

Example output:
```
NAME         TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)        AGE   SELECTOR
kubernetes   ClusterIP      172.20.0.1       <none>                                                                    443/TCP        14m   <none>
nginx        LoadBalancer   172.20.249.182   a4adc5bc26f9b44618c1a494f9516b40-1770948926.us-east-1.elb.amazonaws.com   80:30213/TCP   8s    app=web
```

## How LoadBalancer Works

- Port 80 (LoadBalancer) → Port 30213 (NodePort)
- NodePort is automatically assigned by Kubernetes
- kube-proxy routes traffic from NodePort to target Pod port
- All requests: LoadBalancer → NodePort → kube-proxy → Pod

## Important Notes

### Cleanup Order

**⚠️ IMPORTANT**: Delete LoadBalancer services before running `terraform destroy`

```bash
# 1. Delete Kubernetes LoadBalancer services
kubectl delete svc nginx

# 2. Wait for AWS LoadBalancer to be deleted (check AWS Console)

# 3. Then destroy Terraform resources
terraform destroy
```

**Why?** LoadBalancer services create AWS ELBs that use VPC/subnets created by Terraform. If you destroy Terraform first, it will wait indefinitely because the ELB still has dependencies on the VPC.

## Key Concepts

### before_compute
Tells Terraform to ensure that EKS addon is fully created, updated, or configured before node group is created. This prevents dependency issues.

### most_recent
Ensures that EKS addon uses the most recent version of the Amazon plugin available for the cluster version.

## Troubleshooting

If `terraform destroy` hangs:
1. Check for LoadBalancer services: `kubectl get svc`
2. Delete them: `kubectl delete svc <service-name>`
3. Verify ELBs are deleted in AWS Console
4. Retry `terraform destroy`  
