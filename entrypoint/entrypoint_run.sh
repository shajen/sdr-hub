#!/bin/bash

LOG_FILE=/var/log/sdr/startup.log
set -e

echo "Details" | tee -a $LOG_FILE
print_info | tee -a $LOG_FILE

echo "Running setup" &>>$LOG_FILE
setup_broker &>>$LOG_FILE
setup_data &>>$LOG_FILE
setup_monitor &>>$LOG_FILE
setup_scanner &>>$LOG_FILE
setup_supervisor &>>$LOG_FILE

[ ! -n "$SDR_SCANNER_ID" ] && export SDR_SCANNER_ID="$(cat /var/run/sdr/sdr-scanner-id)"
echo "Starting supervisor" | tee -a $LOG_FILE
supervisord -c /etc/supervisor/conf.d/supervisord.conf
