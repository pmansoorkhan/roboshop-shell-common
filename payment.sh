#!/bin/bash

source ./common.sh
app_name="payment"

Check_root
python_setup
app_setup
systemd_setup


app_restart
print_total_time
