#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\E[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE= "/tmp/$0-$TIMESTAMP.log"
exec &>$LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
      echo -e "$2... $R FAILED $N"
      exit1
    else
      echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then 
  echo -e "you are not root user...$R Error $N"
  exit 1
else
  echo -e "you are root user...$G success $N"
fi

echo "script started execting at $TIME "

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
VALIDATE $? "installing redis packages...$G success $N"

dnf module enable redis:remi-6.2 -y
VALIDATE $? "enable redis packages...$G success $N"

dnf install redis -y
VALIDATE $? "installing redis...$G success $N"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
VALIDATE $? "allowing remote connections...$G success $N"

systemctl enable redis
VALIDATE $? "Enabled Redis...$G success $N"

systemctl start redis
VALIDATE $? "started Redis...$G success $N"
