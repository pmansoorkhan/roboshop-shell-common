#!/bin/bash

source ./common.sh

Check_root

cp "$SCRIPT_DIR/mongo.repo"  /etc/yum.repos.d/mongo.repo 
VALIDATE "$?" "Copying mongo repo file"

dnf install mongodb-org -y  &>> "$LOG_FILE"   
VALIDATE "$?" "Installing  mongodb"

systemctl enable mongod &>> "$LOG_FILE" 
VALIDATE "$?" "Enabling mongodb service"

systemctl start mongod &>> "$LOG_FILE" 
VALIDATE "$?" "Starting mongodb service"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf
VALIDATE "$?" "Updating mongodb config file" 
 
systemctl restart mongod &>> "$LOG_FILE"
VALIDATE "$?" "Restarted mongodb service"

Print_total_time