## Provision eks by aws eks module

- used doc: https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

## Cmd
# config kubeconfig
```
aws eks update-kubeconfig --region us-east-1 --name Terra-EKS
```

# Things to remember
- 1st delte loadbalancer from cluster and then only run ```terraform destroy```
- as it will make dependency wait and destroy will wait as lb is using vpc or subnet which created by vpc defined in terraform code

# How loadbalancer working here to 
- if you see output of service we can it binds 80 to 30213
- 80 is incomeing loadbalancer and 30213 is node port but in service we havnt specified 
- in k8s all requests come to nodeport then kubeproxy is responsible to bind that nodeport to actual target port and route request
```
kubectl get svc -o wide

NAME         TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)        AGE   SELECTOR
kubernetes   ClusterIP      172.20.0.1       <none>                                                                    443/TCP        14m   <none>
nginx        LoadBalancer   172.20.249.182   a4adc5bc26f9b44618c1a494f9516b40-1770948926.us-east-1.elb.amazonaws.com   80:30213/TCP   8s    app=web
```

### Questions/Doubts
- before_compute: tells terraform to ensure that addon is fully created, updated or configured before node group created
- most_recent: ensure that eks addon uses most recent version of amazon plugin  
