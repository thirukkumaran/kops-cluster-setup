#!/usr/bin/env bash


if [ $# -eq 0 ]; then
    echo "Usage : k8-cluster-a-setup {cluster name} {master nodes count} {worker nodes count}"
    exit 1
fi

S3_BUCKET=$1-state
K8_CLUSTER_NAME=$1
#K8_CLUSTER_NAME=$1.k8s.local
DNS_ZONE_PUBLIC_ID=$4
MASTER_COUNT=$2
NODE_COUNT=$3
REGION="ap-southeast-1"


echo "K8 cluster name : " $1
echo "Master nodes count :" $2
echo "Worker nodes count :"$3
echo "dns zone public id :"$4

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
--topology public \
#--dns public \
#--dns-zones ${DNS_ZONE_PUBLIC_ID} \
--networking cni \
--yes

echo " k8 cluster ${K8_CLUSTER_NAME} creation in progress "
