#!/bin/bash

source ./common.sh
app_name="redis"

Check_root

dnf module disable redis -y &>> "$LOG_FILE"
dnf module enable redis:7 -y  &>> "$LOG_FILE"
VALIDATE "$?" "Disabling and Enabling the Redis version"

dnf install redis -y  &>> "$LOG_FILE"
VALIDATE "$?" "Installing Redis"

sed -i -e "s/127.0.0.1/0.0.0.0/g"  -e " /protected-mode/ c protected-mode no" /etc/redis/redis.conf
VALIDATE "$?" "Changing the config"

systemctl enable redis  &>> "$LOG_FILE"
systemctl start redis
VALIDATE "$?" "Enabling & Staerted Redis"

print_total_time