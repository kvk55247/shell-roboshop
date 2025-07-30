#!/bin/bash

#!/bin/bash
zoneid=Z02592383JVQTDY6U9ADB
recordname=$instance
recordvalue=$IP

for instance in ${INSTANCES[@]}
do

aws route53 change-resource-record-sets \
  --hosted-zone-id $zoneid \
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