#!/bin/bash



AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0df304cc4c6711e85"
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")
ZONE_ID="Z02592383JVQTDY6U9ADB"
DOMAIN_NAME="daws84s.info"

for instance in ${INSTANCES[@]}
do
   INSTACE_ID=$(aws ec2 run-instances \
  --image-id ami-09c813fb71547fc4f \
  --instance-type t3.micro \
  --security-group-ids sg-0df304cc4c6711e85 \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value='$instance'}]'   --query 'Reservations[*].Instances[*].InstanceId' \
  --output text)
  if [ $instance != "frontend" ]
  then
      IP=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --query 'Reservations[0].Instances[0].PrivateIpAddress' \
  --output text)
  else 
    IP=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)
  fi
 echo "$instance IP address: $IP"
 
  aws route53 change-resource-record-sets \
  --hosted-zone-id $ZONE_ID \
  --change-batch '
  {
    "Comment": "Creating or updating a record set for cognito endpoint"
    ,"Changes": [{
      "Action"              : "UPSERT"
      ,"ResourceRecordSet"  : {
        "Name"              : "'$instance'.'$DOMAIN_NAME'"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "'$IP'"
        }]
      }
    }]
  }'
  done