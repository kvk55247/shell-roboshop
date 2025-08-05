!/bin/bash


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
dnf module disable nginx -y &>>$LOG_FILE
VALIDATE $? "disabling default Nginx"

dnf module enable nginx:1.24 -y &>>$LOG_FILE
VALIDATE $? "Enabling Nginx:1.24"
dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "Installing Nginx"
systemctl enable nginx 
VALIDATE $? "Enabling nginx"
systemctl start nginx 
VALIDATE $? "starting nginx"
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "removing default content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOG_FILE
VALIDATE $? "downloading frontend"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "unzipping frontend"

rm -rf /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE $? "remove default nginx.conf"
cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE $? "copying nginx.conf"

systemctl restart nginx 
VALIDATE $? "restarting nginx"
