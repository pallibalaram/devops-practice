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

dnf module disable mysql -y &>> $LOG
VALIDATE $? "mysql disabled"

cp /C/Users/BALARAM/repo/mysql.repo /etc/yum.repos.d/mysql.repo
VALIDATE $? "Copied Mysql Repo"

dnf install mysql-community-server -y  &>> $LOG
VALIDATE $? "installing mysql"

systemctl enable mysqld &>> $LOG
VALIDATE $? "enabled mysqld"

systemctl start mysqld &>> $LOG
VALIDATE $? "started mysqld"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "setting mysqld root passwd"



