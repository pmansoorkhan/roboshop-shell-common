#!/bin/bash

source ./common.sh
MYSQL_ROOT_PASSWORD="RoboShop@1"
app_name=mysql


Check_root

dnf install mysql-server  -y  &>> "$LOG_FILE"
VALIDATE "$?" "Installing MySql server"

systemctl enable mysqld &>> "$LOG_FILE" 
systemctl start mysqld  &>> "$LOG_FILE"
VALIDATE "$?" "Enabling & Starting MYSql service"

mysql_secure_installation --set-root-pass "$MYSQL_ROOT_PASSWORD"
#mysql_secure_installation --set-root-pass RoboShop@1 &>> "$LOG_FILE"
VALIDATE "$?" "Setting Root Credentials"

print_total_time

