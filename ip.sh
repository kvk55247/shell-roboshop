#!/bin/bash


AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0df304cc4c6711e85"
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")
ZONE_ID="Z02592383JVQTDY6U9ADB"
DOMAIN_NAME=" daws84s.info "


for instance in ${INSTANCES[@]}
do

aws route53 change-resource-record-sets \
  --hosted-zone-id $ZONE_ID \
  --change-batch '
  {
    "Comment": "Creating or updating a record set for cognito endpoint"
    ,"Changes": [{
      "Action"              : "UPSERT"
      ,"ResourceRecordSet"  : {
        "Name"              : "'$INSTANCE'.'$DOMAIN_NAME'"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "'$IP'"
        }]
      }
    }]
  }'
  done