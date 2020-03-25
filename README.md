# kops-cluster-setup

## Run the scripts in order to create k8 cluster in AWS

```
cd setup-k8-cluster
install-prep.sh
create-iam-user.sh
set-kops-user.sh
k8-cluster-setup.sh

```

## backend  setup

```
cd backend-setup
kubectl apply -f redis-deployment.yaml
kubectl apply -f redis-service.yaml

```

## frontend  setup

```
cd frontend-setup
kubectl apply -f myapp-deployment.yml
kubectl apply -f myapp-service.yml

```
