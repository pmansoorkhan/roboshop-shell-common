#!/bin/bash

source ./common.sh
RABBITMQ_USER="roboshop"
RABBITMQ_PASSWORD="roboshop123"

#app_name="rabbitmq"

Check_root

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo  &>> "$LOG_FILE"

dnf install rabbitmq-server -y   &>> "$LOG_FILE"
VALIDATE "$?" "Installing RabbitMQ"

systemctl enable rabbitmq-server  &>> "$LOG_FILE"
systemctl start rabbitmq-server   &>> "$LOG_FILE"
VALIDATE "$?" "Enabling & Starting RAbbitMQ service"


rabbitmqctl add_user "$RABBITMQ_USER" "$RABBITMQ_PASSWORD" &>> "$LOG_FILE"
rabbitmqctl set_permissions -p / "$RABBITMQ_USER" ".*" ".*" ".*" &>> "$LOG_FILE"
#rabbitmqctl add_user roboshop roboshop123   &>> "$LOG_FILE"
#rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"   &>> "$LOG_FILE"
VALIDATE "$?" "Adding and Giving permissions"

print_total_time
