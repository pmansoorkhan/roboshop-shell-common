#!/bin/bash

source ./common.sh
app_name="frontend"
app_dir=/usr/share/nginx/html


Check_root

dnf module list nginx -y &>> "$LOG_FILE"
VALIDATE "$?" "checking the list of modules"

dnf module disable nginx -y &>> "$LOG_FILE"
VALIDATE "$?" "Disabling all modules"

dnf module enable nginx:1.24 -y &>> "$LOG_FILE"
VALIDATE "$?" "Enabling the required module"

dnf install nginx -y  &>> "$LOG_FILE"
VALIDATE "$?" "Installing nginx"

systemctl enable nginx  &>> "$LOG_FILE"
systemctl start nginx  &>> "$LOG_FILE"
VALIDATE "$?" "Enabling & Starting nginx"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "Remove default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> "$LOG_FILE"
VALIDATE "$?" "Downloading Frontend zip file"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip  &>> "$LOG_FILE"
VALIDATE $? "Downloading  and unzipping frontend"

rm -rf /etc/nginx/nginx.conf  &>> "$LOG_FILE"
VALIDATE $? "Remove default content"

cp "$SCRIPT_DIR/nginx.conf"  /etc/nginx/nginx.conf  &>> "$LOG_FILE"
VALIDATE $? "Copying  our nginx conf file"

systemctl restart nginx &>> "$LOG_FILE"
VALIDATE $? "Restarted Nginx"

print_total_time