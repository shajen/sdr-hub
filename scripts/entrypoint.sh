#!/bin/bash
set -e

echo "Running setup..."
setup_broker
setup_data
setup_monitor
setup_supervisor

echo "Starting supervisor..."
exec supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
