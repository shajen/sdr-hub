#!/bin/bash

function start_mysql {
    echo "Starting mysqld"
    mysqld --initialize --init-file=/usr/local/bin/mysql-init.sql || true
    mysqld &
    echo "Waiting for mysqld to be ready"
    wait4x mysql "sdr:sdr@tcp(127.0.0.1:3306)/sdr" -q -t 10m
}

function stop_mysql {
    echo "Stopping mysqld"
    MYSQLD_PID=$(pidof mysqld)
    kill -TERM "$MYSQLD_PID"
    echo "Waiting for mysqld to exit"
    wait "$MYSQLD_PID"
    echo "Stopped mysqld"
}

LOG_FILE=/var/log/sdr/startup.log
set -e

echo "Details" | tee -a $LOG_FILE
print_info | tee -a $LOG_FILE

echo "Running setup" &>>$LOG_FILE
start_mysql &>>$LOG_FILE
setup_broker &>>$LOG_FILE
setup_data &>>$LOG_FILE
setup_monitor &>>$LOG_FILE
setup_mysql &>>$LOG_FILE
setup_scanner &>>$LOG_FILE
setup_supervisor &>>$LOG_FILE
migrate_db 2>&1 | tee -a $LOG_FILE
stop_mysql &>>$LOG_FILE

[ ! -n "$SDR_SCANNER_ID" ] && export SDR_SCANNER_ID="$(cat /var/run/sdr/sdr-scanner-id)"
[ ! -n "$SECRET_KEY" ] && export SECRET_KEY="$(cat /var/run/sdr/sdr-monitor-secret-key)"
echo "Starting supervisor" | tee -a $LOG_FILE
exec supervisord
