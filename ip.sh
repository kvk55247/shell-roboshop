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

  EXISTING_TXT_VALUES=$(aws route53 list-resource-record-sets \
    --hosted-zone-id "$HOSTED_ZONE_ID" \
    --query "ResourceRecordSets[?Name == '$RECORD_NAME.' && Type == 'TXT'].ResourceRecords[].Value" \
    --output text)

echo $EXISTING_TXT_VALUES

#output
"v=spf1 include:amazonses.com -all" "TestValue1" "TestValue2"