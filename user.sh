#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\E[0m"
TIME=$(date +%F-%H-%M-%S)
LOG= "/tmp/$0-$TIME.log"
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

dnf module disable nodejs -y &>> $LOG
VALIDATE $? "nodejs disabled"

dnf module enable nodejs:18 -y &>> $LOG
VALIDATE $? "nodejs enabled"

dnf install nodejs -y &>> $LOG
VALIDATE $? " nodejs install"

id roboshop
if [ $? -ne 0 ]
then 
  useradd roboshop
  VALIDATE $? "roboshop user created"
else
  echo -e "alrady user exists"
fi

mkdir /app -p
VALIDATE $? "creating app directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip
VALIDATE $? "Downloading user application"

cd /app 

unzip -o /tmp/user.zip  &>> $LOG

VALIDATE $? "unzipping user"

npm install  &>> $LOG

VALIDATE $? "Installing dependencies"

cp /c/users/BALARAM/repo/user.service /etc/systemd/system/user.service 

VALIDATE $? "Copying user service file"

systemctl daemon-reload &>> $LOG

VALIDATE $? "user daemon reload"

systemctl enable user &>> $LOG

VALIDATE $? "Enable user"

systemctl start user &>> $LOG

VALIDATE $? "Starting user"

cp /c/users/BALARAM/repo/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "copying mongodb repo"

dnf install mongodb-org-shell -y &>> $LOG

VALIDATE $? "Installing MongoDB client"

mongo --host $MONGDB_HOST </app/schema/user.js &>> $LOG

VALIDATE $? "Loading user data into MongoDB"






