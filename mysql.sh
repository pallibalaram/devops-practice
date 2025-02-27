#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
MONGDB_HOST=mongodb.pavan.dev.online
VALIDATE(){
  if [ $1 -ne 0 ]
  then
    echo -e "$2...$R FAILED $N"
    exit1
  else
    echo -e "$2...$G success $N"
  fi
}
if [ $ID -ne  0 ]
then
  echo -e "$R ERROR:: Please run this script with root access $N"
  exit1
else
  echo "you are Root User"
fi

echo "script stareted executing at $TIMESTAMP" &>> $LOGFILE

dnf module disable mysql -y &>> $LOGFILE
VALIDATE $? "mysql disabled"

cp /home/centos/devops-practice/mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE
VALIDATE $? "Copied Mysql Repo"

dnf install mysql-community-server -y  &>> $LOGFILE
VALIDATE $? "installing mysql"

systemctl enable mysqld &>> $LOGFILE
VALIDATE $? "enabled mysqld"

systemctl start mysqld &>> $LOGFILE
VALIDATE $? "started mysqld"

mysql_secure_installation --set-root-pass RoboShop@1 $LOGFILE
VALIDATE $? "setting mysqld root passwd"



