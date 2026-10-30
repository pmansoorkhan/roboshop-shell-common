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

Check_root() {
if [ "$USER_ID" -ne 0 ]; then
    echo -e "${R}Please run the script as root user${N}"
    exit 1
fi
}

mkdir -p "$LOG_FOLDER"     # Create log directory

VALIDATE() {
    if [ "$1" -ne 0 ]; then
        echo -e "${R}$2 .... is failed${N}" | tee -a "$LOG_FILE"
        exit 1
    else
        echo -e "${G}$2 ...... is successful${N}" | tee -a "$LOG_FILE"
    fi
}
