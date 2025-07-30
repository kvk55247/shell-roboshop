#!/bin/bash
#!/bin/bash

# Input variables
HOSTED_ZONE_ID="Z02592383JVQTDY6U9ADB"  # Replace with your actual Hosted Zone ID
DOMAIN_NAME_NAME="daws84s.info"
RECORD_TYPE="A"
RECORD_TTL=1
RECORD_VALUE="$IP"  # Replace with your IP or record value

# Create the JSON file for the change batch
cat > change-batch.json << EOF
{
  "Comment": "UPSERT record via shell script",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "$DOMAIN_NAME",
        "Type": "A",
        "TTL": 1,
        "ResourceRecords": [
          {
            "Value": "$IP"
          }
        ]
      }
    }
  ]
}
EOF

# Call AWS CLI to apply the change
aws route53 change-resource-record-sets \
    --hosted-zone-id "$HOSTED_ZONE_ID" \
    --change-batch file://change-batch.json

# Clean up
rm change-batch.json
