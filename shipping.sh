#!/bin/bash

source ./common.sh
app_name="shipping"

check_root
app_setup
java_setup
systemd_setup


dnf install mysql -y  &>> "$LOG_FILE" 
VALIDATE "$?" "Installing MYSQL"


mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities'
if [ "$?" -ne 0 ]; then
     mysql -h "$MYSQL_HOST" -uroot -pRoboShop@1 < /app/db/schema.sql
     mysql -h "$MYSQL_HOST" -uroot -pRoboShop@1 < /app/db/app-user.sql 
     mysql -h "$MYSQL_HOST" -uroot -pRoboShop@1 < /app/db/master-data.sql
     VALIDATE "$?" "Loading data into MYSQL"
else 
    echo -e "$(date "+%Y-%m-%d %H:%M:%S")  | ${G} Data is already loaded ${N} .....${Y} Skipping ${N}"
fi
    
app_restart
print_total_time
