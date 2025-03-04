#!/bin/bash
AMI=ami-0b4f379183e5706b9
SG_ID=sg-07d8372baed539857
ZONE_ID=Z05391511HI4N0V6H16ZN
DOMIAN_NAME="pavandev.online"
INSTANCES=( "mongodb" "catalogue" "cart" "user" "redis" "web" "mysql" "shipping" "rabbitmq" "payment" )
for i in "${INSTANCES[@]}"
do
    if [ $i==mongodb ] || [ $i==shipping ] || [ $i==mysql ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi
    IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI --instance-type $INSTANCE_TYPE--security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)
    echo "$i: $IP_ADDRESS"
    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
      {
        "Comment": "Testing creating a record set"
        ,"Changes": [{
          "Action"              : "CREATE"
          ,"ResourceRecordSet"  : {
            "Name"              : "' $i'.'$DOMIAN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'" $IP_ADDRESS "'"
            }]
          }
        }]
      }
      '
        

done
