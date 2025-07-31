#!/bin/bash


USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m]"
LOGS_FOLDER="/var/logs/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut  -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "script started executing at: $(date)" tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: please run this script with root access $N"  tee -a $LOG_FILE
    exit 1
else
    echo "you are running with root access"  tee -a $LOG_FILE
fi

VALIDATE(){
 if [ $? -eq 0 ]
then
    echo "$2 is .... success"  tee -a $LOG_FILE
else
    echo " $2 is ....FAILURE"  tee -a $LOG_FILE
    exit 1
fi
}
 cp mongo.repo /etc/yum.repos.d/mongo.repo
 VALIDATE $? "copying mongo.repo"

 dnf install mongodb-org -y &>>$LOG_FILE
 VALIDATE $? "installing mongoDB server"

 systemctl enable mongod &>>$LOG_FILE
 VALIDATE $? "enabling mongoDB"

 systemctl start mongod &>>$LOG_FILE
 VALIDATE $? "starting mongoDB"
  sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf 
  VALIDATE $? "Editing mongoDB conf file for rempote connections"

  systemctl restart mongod &>>$LOG_FILE
  VALIDATE $? "Restarting mongoDB"
