#!/bin/bash

#!/bin/bash

# Replace with your hosted zone ID
HOSTED_ZONE_ID="Z02592383JVQTDY6U9ADB"

# Create temp JSON file with change batch
cat > change-batch.json <<EOF
{
  "Comment": "Creating 3 A records",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "daws84s.info",
        "Type": "A",
        "TTL": 1,
        "ResourceRecords": [{ "Value": "$IP" }]
      }
    },
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "daws84s.info",
        "Type": "A",
        "TTL": 1,
        "ResourceRecords": [{ "Value": "$IP" }]
      }
    },
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "daws84s.info",
        "Type": "A",
        "TTL": 1,
        "ResourceRecords": [{ "$IP" }]
      }
    }
  ]
}
EOF

# Submit the change batch to Route 53
aws route53 change-resource-record-sets --hosted-zone-id "$HOSTED_ZONE_ID" --change-batch file://change-batch.json
