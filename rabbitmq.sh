#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

if [ $ID -ne 0 ]
then
  echo"you are not root user...$R FAILED $N"
  exit1
else
  echo"you are root user...$G SUCCESS $N"
fi
VALIDATE(){
    if [ $1 -ne 0 ]
    then
      echo -e "$2... $R FAILED $N"
      exit1
    else
      echo -e "$2...$G SUCCESS $N"
    fi
}

echo "script stareted executing at $TIMESTAMP" &>> $LOGFILE

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE
VALIDATE $? "Downloading erlang script"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE
VALIDATE $? "Downloading rabbitmq script"

dnf install rabbitmq-server -y  &>> $LOGFILE
VALIDATE $? "Installing RabbitMQ server"

systemctl enable rabbitmq-server &>> $LOGFILE
VALIDATE $? "Enabling rabbitmq server" 

systemctl start rabbitmq-server &>> $LOGFILE
VALIDATE $? "Starting rabbitmq server"

rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE
VALIDATE $? "creating user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE
VALIDATE $? "setting permission"
   





