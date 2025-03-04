#!/bin/bash

AMI=ami-0b4f379183e5706b9
SG_ID=sg-07f92a2d97f3700e2 
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
ZONE_ID=Z05391511HI4N0V6H16ZN 
DOMAIN_NAME="pavandev.online"

for i in "${INSTANCES[@]}"
do
    echo "instance is : $i"
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    aws ec2 run-instances --image-id $AMI --instance-type $INSTANCE_TYPE --security-group-ids sg-07f92a2d97f3700e2 
done