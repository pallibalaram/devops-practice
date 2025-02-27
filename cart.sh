#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\E[0m"
TIME=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIME.log"
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

dnf module disable nodejs -y  &>> $LOGFILE
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
  echo -e "alrady user exists"
fi

mkdir -p /app &>> $LOG
VALIDATE $? "Creating directory"

curl -o curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE
VALIDATE $? " storing in temporary location"

cd /app &>> $LOG
VALIDATE $? "changing directory to app" 

unzip /tmp/cart.zip &>> $LOGFILE
VALIDATE $? "unzipping cart"

npm install &>> $LOGFILE
VALIDATE $? " npm installation"

cp /home/centos/devops-practice/cart.service /etc/systemd/system/cart.service &>> $LOGFILE
VALIDATE $? "coping to cart service"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "reloading systemctl"

systemctl enable cart &>> $LOGFILE
VALIDATE $? "enabling cart"

systemctl start cart &>> $LOGFILE
VALIDATE $? "starting cart"










