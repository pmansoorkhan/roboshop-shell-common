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

echo "$(date "+%Y-%m-%d %H:%M:%S")  | Script started executing at: $(date)"  | tee -a "$LOG_FILE"

Check_root() {
if [ "$USER_ID" -ne 0 ]; then
    echo -e "${R}Please run the script as root user${N}"
    exit 1
fi
}

mkdir -p "$LOG_FOLDER"     # Create log directory

VALIDATE() {
    if [ "$1" -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S")  | $2 .... is  ${R} failed ${N}" | tee -a "$LOG_FILE"
        exit 1
    else
        echo -e "$(date "+%Y-%m-%d %H:%M:%S")  | $2 ..... is  ${G} successful$ {N}" | tee -a "$LOG_FILE"
    fi
}

Print_total_time(){
END_TIME="$(date +%s)"
TOTAL_TIME=$(( "$END_TIME" - "$START_TIME" ))
echo -e "$(date "+%Y-%m-%d %H:%M:%S")  | Script executed in :"${G} $TOTAL_TIME" seconds ${N}"  | tee -a "$LOG_FILE"
}
