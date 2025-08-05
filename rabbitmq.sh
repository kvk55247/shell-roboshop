#!/bin/bash


START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m]"
LOGS_FOLDER="/var/logs/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

mkdir -p $LOGS_FOLDER
echo "script started executing at: $(date)" tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: please run this script with root access $N"  tee -a $LOG_FILE
    exit 1
else
    echo "you are running with root access"  tee -a $LOG_FILE
fi

echo "please enter root password to setup"
read -s $RABBITMQ_PASSWD


VALIDATE(){
 if [ $? -eq 0 ]
then
    echo "$2 is .... success"  tee -a $LOG_FILE
else
    echo " $2 is ....FAILURE"  tee -a $LOG_FILE
    exit 1
fi
}

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "adding rabbitmq.repo"

dnf install rabbitmq-server -y
VALIDATE $? "installing rabbitmq-server"

systemctl enable rabbitmq-server
systemctl start rabbitmq-server
VALIDATE $? "starting rabbitmq-server"

rabbitmqctl add_user roboshop $RABBITMQ_PASSWD
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"



END_TIME=$(date +%s) &>>$LOG_FILE
TOTAL_TIME=$(( $END_TIME - $START_TIME)) &>>$LOG_FILE

echo -e "script execution completed successfully, $Y time taken: $TOTAL_TIME seconds $N" | tee -a $LOG_FILE

