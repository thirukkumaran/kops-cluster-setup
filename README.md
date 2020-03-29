# kops-cluster-setup

## Run the scripts in order to create k8 cluster in AWS,
## set AWS credentials to create kops IAM user

```
cd setup-k8-cluster

install-prep.sh
create-iam-user.sh
set-kops-user.sh

k8-cluster-a-setup {backend cluster name} {master nodes count} {worker nodes count}

k8-cluster-b-setup {frontend cluster name} {master nodes count} {worker nodes count}

```


## backend setup

```
cd backend-setup
kubectl config use-context  <backend cluster name>
kubectl apply -f backend-namespace.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
kubectl apply -f backend-ingress.yaml

```

1. Point backend domain to backend ALB


## frontend  setup

```
cd frontend-setup
kubectl config use-context  <frontend cluster name>
kubectl apply -f frontend-namespace.yaml
kubectl apply -f frontend-deployment.yml
kubectl apply -f frontend-service.yml
kubectl apply -f frontend-ingress.yml

```

1. create VPC peering between frontend and backend VPC
2. Point frontend domain to frontend ALB


## Access the link with https://frotend-domain
