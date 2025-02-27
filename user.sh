#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\E[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
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

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "nodejs disabled"

dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "nodejs enabled"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? " nodejs install"

id roboshop
if [ $? -ne 0 ]
then 
  useradd roboshop
  VALIDATE $? "roboshop user created"
else
  echo -e "already user exists...$Y SKIPPING $N"
fi

mkdir /app -p &>> $LOGFILE
VALIDATE $? "creating app directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE
VALIDATE $? "Downloading user application"

cd /app 

unzip -o /tmp/user.zip  &>> $LOGFILE

VALIDATE $? "unzipping user"

npm install  &>> $LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/devops-practice/user.service /etc/systemd/system/user.service &>> $LOGFILE

VALIDATE $? "Copying user service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "user daemon reload"

systemctl enable user &>> $LOGFILE

VALIDATE $? "Enable user"

systemctl start user &>> $LOGFILE

VALIDATE $? "Starting user"

cp /home/centos/devops-practice/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copying mongodb repo"

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "Installing MongoDB client"

mongo --host $MONGDB_HOST </app/schema/user.js &>> $LOGFILE

VALIDATE $? "Loading user data into MongoDB"






