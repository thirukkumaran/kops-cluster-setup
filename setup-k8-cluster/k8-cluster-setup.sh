#!/usr/bin/env bash



S3_BUCKET=$1-state
K8_CLUSTER_NAME=$1.k8s.local
MASTER_COUNT=$2
NODE_COUNT=$3
REGION=ap-southeast-1

if [ $# -eq 0 ]; then
    echo "Usage : k8-cluster-setup {cluster name} {master nodes count} {worker nodes count}"
    exit 1
fi

echo "K8 cluster name : " $1
echo "Master nodes count :" $2
echo "Worker nodes count :"$3

if [ $MASTER_COUNT == 1 ];
then
MASTER_ZONES=ap-southeast-1a
elif [ $MASTER_COUNT == 2 ];
 then
  MASTER_ZONES=ap-southeast-1a,ap-southeast-1
elif [ $MASTER_COUNT == 3 ];
 then
     MASTER_ZONES=ap-southeast-1a,ap-southeast-1b,ap-southeast-1c
fi


echo "Master node zone : " $MASTER_ZONES


if [ $NODE_COUNT == 1 ];
then
NODE_ZONES=ap-southeast-1a
elif [ $NODE_COUNT == 2 ];
 then
  NODE_ZONES=ap-southeast-1a,ap-southeast-1
elif [ $NODE_COUNT == 3 ];
 then
     NODE_ZONES=ap-southeast-1a,ap-southeast-1b,ap-southeast-1c
fi

echo "Worker node zone : " $NODE_ZONES

# bucket creation

aws s3api create-bucket --bucket ${S3_BUCKET} --region ${REGION} --create-bucket-configuration LocationConstraint=${REGION}
KOPS_STATE_STORE=s3://${S3_BUCKET}

echo "s3 bucket to store state : " ${S3_BUCKET}

#create pub secret

#PUB_KEY=$1.pub
#kops create secret --name ${K8_CLUSTER_NAME} sshpublickey admin -i ${PUB_KEY} --state s3://${S3_BUCKET}

#create k8 gossip-cluster

kops create cluster \
--cloud=aws \
--master-count=${MASTER_COUNT} \
--node-count=${NODE_COUNT} \
--master-size=t2.micro \
--node-size=t2.micro \
--master-zones=${MASTER_ZONES} \
--zones=${NODE_ZONES} \
--state=${KOPS_STATE_STORE} \
--name=${K8_CLUSTER_NAME} \
#--yes

echo " k8 cluster ${K8_CLUSTER_NAME} creation in progress "

#kubectl create namespace frontend
