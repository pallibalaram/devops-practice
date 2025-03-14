#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGDB_HOST=mongodb.pavandev.online
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
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
    exit 
else
    echo "You are root user"
fi 

echo "script stareted executing at $TIMESTAMP" &>> $LOGFILE

dnf install golang -y 
VALIDATE $? "Install golang"

id roboshop 
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir -p /app
VALIDATE $? "creating app directory"

curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip
VALIDATE $? "Downloading dispatch application"

cd /app 

unzip /tmp/dispatch.zip
VALIDATE $? "unzipping dispatch"

go mod init dispatch

go get 

go build

cp /home/centos/devops-practice/dispatch.service /etc/systemd/system/dispatch.service
VALIDATE $? "Copying dispatch service file"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "dispatch daemon reload"

systemctl enable dispatch &>> $LOGFILE
VALIDATE $? "Enable dispatch"

systemctl start dispatch &>> $LOGFILE
VALIDATE $? "Starting dispatch"