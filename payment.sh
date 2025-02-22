#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGDB_HOST=mongodb.daws76s.online

TIMESTAMP=$(date +%F-%H-%M-%S)
LOG="/tmp/$0-$TIMESTAMP.log"

echo "script stareted executing at $TIMESTAMP" &>> $LOG

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 
else
    echo "You are root user"
fi 

dnf install python36 gcc python3-devel -y &>> $LOG

id roboshop 
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir -p /app &>> $LOG

VALIDATE $? "creating app directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOG

VALIDATE $? "Downloading payment"

cd /app 

unzip -o /tmp/payment.zip &>> $LOG

VALIDATE $? "unzipping payment"

pip3.6 install -r requirements.txt &>> $LOG

VALIDATE $? "Installing Dependencies"

cp /C/users/BALARAM/repo/payment.service /etc/systemd/system/payment.service &>> $LOG

VALIDATE $? "Copying payment service"

systemctl daemon-reload &>> $LOG

VALIDATE $? "daemon reaload"

systemctl enable payment  &>> $LOG

VALIDATE $? "Enable payment"

systemctl start payment &>> $LOG

VALIDATE $? "Start payment"