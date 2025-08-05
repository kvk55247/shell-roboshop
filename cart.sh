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

VALIDATE(){
 if [ $? -eq 0 ]
then
    echo "$2 is .... success"  tee -a $LOG_FILE
else
    echo " $2 is ....FAILURE"  tee -a $LOG_FILE
    exit 1
fi
}
dnf module disable nodejs -y
VALIDATE $? "disbaling default nodejs"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "Enabling nodejs:20"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "installing nodejs"

id roboshop
if [ $? -ne 0 ]
then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
VALIDATE $? "Creating roboshop system user"
else
echo -e "system user roboshop already created..... $Y SKIPPING $N"
fi

mkdir -p /app &>>$LOG_FILE
VALIDATE $? "creating directory"

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip
VALIDATE $? "downloading cart"

rm -rf /app/*
cd /app 
unzip /tmp/cart.zip &>>$LOG_FILE
VALIDATE $? "unzipping cart"

npm install &>>$LOG_FILE
VALIDATE $? "installing dependencies"

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service &>>$LOG_FILE
VALIDATE $? "copying cart.service"

systemctl daemon-reload &>>$LOG_FILE
systemctl enable cart &>>$LOG_FILE
systemctl start cart
VALIDATE $? "starting cart"


END_TIME=$(date +%s) &>>$LOG_FILE
TOTAL_TIME=$(( $END_TIME - $START_TIME)) &>>$LOG_FILE

echo -e "script execution completed successfully, $Y time taken: $TOTAL_TIME seconds $N" | tee -a $LOG_FILE

