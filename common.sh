#!/bin/bash
USER_ID=$(id -u)
LOG_FOLDER="/var/log/roboshop-shell-common"
SCRIPT_NAME=$(basename "$0")
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
B="\e[34m"
START_TIME="$(date +%s)"
SCRIPT_DIR="$PWD"
MONGODB_HOST="mongodb.shannu.online"

echo "$(date "+%Y-%m-%d %H:%M:%S")  | Script started executing at:$(date)"  | tee -a "$LOG_FILE"
mkdir -p "$LOG_FOLDER"     # Create log directory
Check_root() {
if [ "$USER_ID" -ne 0 ]; then
    echo -e "$(date "+%Y-%m-%d %H:%M:%S")  | ${R} Please run the script as root user ${N}"
    exit 1
fi
}

VALIDATE() {
    if [ "$1" -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S")  | $2 ....${R} failed ${N}" | tee -a "$LOG_FILE"
        exit 1
    else
        echo -e "$(date "+%Y-%m-%d %H:%M:%S")  | $2 .....${G} successful ${N}" | tee -a "$LOG_FILE"
    fi
}

nodejs_setup(){

    dnf module list nodejs &>> "$LOG_FILE"
    VALIDATE "$?" "checking NODEJS module list"

    dnf module  disable nodejs -y &>> "$LOG_FILE"
    VALIDATE "$?" "disabling the NODEJS module"

    dnf module enable nodejs:20 -y &>> "$LOG_FILE"
    VALIDATE "$?" "Enabling the NODEJS module"

    dnf install nodejs -y &>> "$LOG_FILE"
    VALIDATE "$?" "Installing NODEJS"

    npm install  &>> "$LOG_FILE"
    VALIDATE "$?" "Installing nodejs dependencies"
}

app_setup(){
    id roboshop &>> "$LOG_FILE"
        if [ "$?" -ne 0 ]; then
            useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop  &>> "$LOG_FILE"
            VALIDATE "$?" "Creating system user"
        else
            echo -e "$(date "+%Y-%m-%d %H:%M:%S")  | ${Y}roboshop user already exists${N}....${B}Skipping user creation${N}" | tee -a "$LOG_FILE"
        fi

    mkdir -p /app  &>> "$LOG_FILE"
    VALIDATE "$?" "Creating app directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip  &>> "$LOG_FILE"
    VALIDATE "$?" "Downloading $app_name zip file"

    cd /app 
    VALIDATE "$?" "Moving to app directory"

    rm -rf /app/* &>> "$LOG_FILE"
    VALIDATE "$?" "Removing existing content from app directory"

    unzip /tmp/$app_name.zip  &>> "$LOG_FILE"
    VALIDATE "$?" "Extracting $app_name zip file"
}

systemd_setup(){
    cp "$SCRIPT_DIR/$app_name.service"  /etc/systemd/system/$app_name.service &>> "$LOG_FILE"
    VALIDATE "$?" "copying $app_name service file"

    systemctl daemon-reload &>> "$LOG_FILE"
    VALIDATE "$?" "Reloading systemd daemon service"

    systemctl enable $app_name  &>> "$LOG_FILE"
    systemctl start $app_name &>> "$LOG_FILE"
    VALIDATE "$?" "Enabling & Starting $app_name service"

}

app_restart(){
    systemctl restart $app_name  &>> "$LOG_FILE"
    VALIDATE "$?" "Restarted $app_name service"
}

print_total_time(){
END_TIME="$(date +%s)"
TOTAL_TIME=$(( "$END_TIME" - "$START_TIME" ))
echo -e "$(date "+%Y-%m-%d %H:%M:%S")  | Script executed in :"${G} $TOTAL_TIME" seconds ${N}"  | tee -a "$LOG_FILE"
}
