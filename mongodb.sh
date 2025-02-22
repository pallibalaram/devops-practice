ID =$(id -u)
R=\e[31m
G=\e[32m
Y=\e[33m
TIMESTAMP=$(date +%F-%H-%M-%S)
LOG= "/tmp/$0-$TIMESTAMP.log"
validate(){
  if [ $1 -ne 0 ]
  then
    echo -e "$2...failed"
    exit1
  else
    echo -e "$2...success"
  fi
}
if [ $ID -ne  0 ]
then
  echo -e "error : you have to be root user"
  exit1
else
  echo "you are Root User"
fi

echo "script stareted executing at $TIMESTAMP" &>> $LOG

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOG
VALIDATE $? "Copied MongoDB Repo"

dnf install mongodb-org -y  &>> $LOG
VALIDATE $? "installing mongodb"

systemctl enable mongod &>> $LOG
VALIDATE $? "started mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
VALIDATE $? "Remote access to MongoDB"

systemctl restart mongod &>> $LOG 
VALIDATE $? "Restarting MongoDB"





