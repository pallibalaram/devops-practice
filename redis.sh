#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\E[0m"
TIME=$(date +%F-%H-%M-%S)
LOG= "/tmp/$0-$TIME.log"
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

if [ $id -ne 0 ]
then 
  echo -e "you are not root user...$R Error $N"
  exit 1
else
  echo -e "you are root user...$G success $N"
fi

echo "script started execting at $TIME "

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
VALIDATE $? "installing redis packages"

dnf module enable redis:remi-6.2 -y
VALIDATE $? "enable redis packages"

dnf install redis -y
VALIDATE $? "installing redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
VALIDATE $? "allowing remote connections"

systemctl enable redis
VALIDATE $? "Enabled Redis"

systemctl start redis
VALIDATE $? "started Redis"
