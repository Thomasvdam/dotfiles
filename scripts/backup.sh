#!/bin/sh

# Simple script to back up one external drive to another
# Usage: ./backup.sh <source> <destination>
# This script is only run manually by the user, no need to handle the log file (yet)

if [ $# -ne 2 ]; then
    echo "Usage: $0 <source> <destination>"
    exit 1
fi

SOURCE=$1
DESTINATION=$2

if [ ! -d $SOURCE ]; then
    echo "Source volume $SOURCE does not exist or is not mounted"
    exit 1
fi

if [ ! -d $DESTINATION ]; then
    echo "Destination volume $DESTINATION does not exist or is not mounted"
    exit 1
fi

echo "Backing up $SOURCE to $DESTINATION"
rsync -avrzqPh --log-file=./backup.log $SOURCE $DESTINATION \
    --exclude '.DS_Store' \
    --exclude '.Spotlight-V100' \
    --exclude '.TemporaryItems' \
    --exclude '.fseventsd'
echo "Backup completed"
