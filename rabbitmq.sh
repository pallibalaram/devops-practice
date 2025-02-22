#!/bin/bash
ID=$(id -u)
R=\e[31m
G=\e[32m
Y=\e[33m
TIME=$(date +%F-%H-%M-%S)
LOG="/tmp/$0-$TIME.log"

if [ id -ne 0 ]
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
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOG

VALIDATE $? "Downloading erlang script"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOG

VALIDATE $? "Downloading rabbitmq script"

dnf install rabbitmq-server -y  &>> $LOG

VALIDATE $? "Installing RabbitMQ server"

systemctl enable rabbitmq-server &>> $LOG

VALIDATE $? "Enabling rabbitmq server" &>> $LOG

systemctl start rabbitmq-server &>> $LOG

VALIDATE $? "Starting rabbitmq server"

rabbitmqctl add_user roboshop roboshop123 &>> $LOG

VALIDATE $? "creating user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOG

VALIDATE $? "setting permission"
   





