#!/bin/bash
LOG_FILE=/var/log/sdr/startup.log
set -e

echo "Details" | tee -a $LOG_FILE
print_info | tee -a $LOG_FILE

echo "Running setup" &>>$LOG_FILE
setup_broker &>>$LOG_FILE
setup_data &>>$LOG_FILE
setup_monitor &>>$LOG_FILE
setup_supervisor &>>$LOG_FILE

echo "Starting supervisor" | tee -a $LOG_FILE
exec supervisord -c /etc/supervisor/conf.d/supervisord.conf
