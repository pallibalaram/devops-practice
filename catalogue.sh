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

mkdir -p /app &>> $LOG
VALIDATE $? "Creating directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOG
VALIDATE $? " storing in temporary location"

cd /app &>> $LOG
VALIDATE $? "changing directory to app" 

unzip -o /tmp/catalogue.zip &>> $LOG
VALIDATE $? "unzipping catalogue"

cd /app

npm install &>> $LOG
VALIDATE $? " npm installation"

cp /c/users/BALARAM/repo/catalogue.service /etc/systemd/system/catalogue.service &>> $LOG
VALIDATE $? "coping to catalogue service"

systemctl daemon-reload &>> $LOG
VALIDATE $? "reloading systemctl"

systemctl enable catalogue &>> $LOG
VALIDATE $? "enabling catalogue"

systemctl start catalogue &>> $LOG
VALIDATE $? "starting catalogue"

dnf install mongodb-org-shell -y &>> $LOG
VALIDATE $? "install mongodb org"

mongo --host mongodb.pavandev.online </app/schema/catalogue.js &>> $LOG


