#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0df304cc4c6711e85"
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "patment" "dispatch" "frontend")
ZONE_ID="Z02592383JVQTDY6U9ADB"
DOMAIN_NAME="daws84s.info"

for instance in ${INSTANCES[@]}
do
    INSTANCE_ID=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t2.micro --security-group-ids sg-0df304cc4c6711e85 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query "Instances[0].InstanceId" --output text)
    if [ $instance != "frontend" ]
    then
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].privateIpAddress" --output text)
    else
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
    fi
    echo "$instance IP address: $IP"
done