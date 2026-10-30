#!/bin/bash

source ./common.sh
app_name="catalogue"

Check_root
nodejs_setup
app_setup
Systemd_setup

cp "$SCRIPT_DIR/mongo.repo"  /etc/yum.repos.d/mongo.repo &>> "$LOG_FILE"
VALIDATE "$?" "copying mongo repo file"

dnf install mongodb-mongosh -y &>> "$LOG_FILE"
VALIDATE "$?" "Installing mongodb shell"

INDEX=$(mongosh --host $MONGODB_HOST --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ "$INDEX" -le  0 ]; then 
    mongosh --host "$MONGODB_HOST" </app/db/master-data.js &>> "$LOG_FILE"
    VALIDATE "$?" "Loading catalogue products"
else
 echo -e " $(date "+%Y-%m-%d %H:%M:%S")  | ${G}catalogue products already loaded${N}......${Y}Skipping${N}"  
fi

app_restart
Print_total_time