#!/bin/bash

BACKUP_DIR="/var/backups/db"
TIMESTAMP=$(date +%Y%m%d)
BACKUP_FILE="db_backup_${TIMESTAMP}.sql.gz"

# Create backup directory if it doesn't exist
sudo mkdir -p $BACKUP_DIR

# Dump the database from the running docker container and compress it
sudo /usr/bin/docker exec -t postgres_db pg_dump -U trainee appdb | gzip > /tmp/$BACKUP_FILE

# Move to the secure backup directory
sudo mv /tmp/$BACKUP_FILE $BACKUP_DIR/

echo "Backup completed: $BACKUP_DIR/$BACKUP_FILE"

# Set permissions for the backup file
chmod +x db_backup.sh
