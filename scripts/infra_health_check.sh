#!/bin/bash

# Define thresholds and paths
DISK_THRESHOLD=85
LOG_FILE="/var/log/infra_health.log"
CONTAINER_NAME="flask_backend"

# 1. Check System Resources
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
RAM_USAGE=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

echo "--- Health Check: $(date) ---"
echo "CPU: ${CPU_USAGE}% | RAM: ${RAM_USAGE}% | Disk: ${DISK_USAGE}%"

# 2. Check Docker and Container Status
DOCKER_STATUS=$(systemctl is-active docker)
CONTAINER_STATUS=$(sudo /usr/bin/docker inspect -f '{{.State.Running}}' $CONTAINER_NAME 2>/dev/null)

# 3. Trigger Alerts if thresholds are crossed
ALERT_TRIGGERED=false

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "[WARNING] Disk usage is at ${DISK_USAGE}% (Threshold: ${DISK_THRESHOLD}%)"
    ALERT_TRIGGERED=true
fi

if [ "$CONTAINER_STATUS" != "true" ]; then
    echo "[WARNING] Container $CONTAINER_NAME is NOT running!"
    ALERT_TRIGGERED=true
fi

# 4. Log warnings if any
if [ "$ALERT_TRIGGERED" = true ]; then
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$TIMESTAMP] [WARNING] Alert triggered. Disk: ${DISK_USAGE}%, Container: $CONTAINER_STATUS" | sudo tee -a $LOG_FILE
fi
