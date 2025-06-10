#!/bin/bash

#-------------------------------------------
#-            backupbuddy-plus             -
#-           Smar Backup Script            -
#-       Author: Ali Muhammad Hamed        -
#-------------------------------------------

#===================================================
# This script is used to backup files into a tarball file.
# backupbuddy-plus: Smar Backup Script (v1.0)
#===================================================

# Default Values
SRC=""
DEST="$HOME/backup"
TIMESTAMP=$(date +%Y-%m-%d_%H:%M:%S)
TIMESTAMP_NAME=$(date +%Y%m%d_%H%M%S)
VERSION="1.0"

# Usage/help message
show_help(){
    echo "Usage: $0 -s <source_dir> [-d <dest_dir>]"
    echo
    echo "Options:"
    echo " -s Source directory to backup (required)"
    echo " -d Destination directory for backup (default: ${DEST})"
    echo " -h Show help message"
    echo " -v Show version information"
    echo
    echo "Example:"
    echo " $0 -s /path/to/source -d /path/to/destination"    
}

# Parse options
while getopts ":s:d:q:h:v" opt; do
    case $opt in
        s) SRC="$OPTARG" ;;
        d) DEST="$OPTARG" ;;
        h) show_help; exit 0 ;;
        v) echo "backupbuddy-plus version $VERSION"; exit 0 ;;
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
        :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    esac
done

# Validate source directory/file is not empty and exists
if [ -z "$SRC" ]; then
    echo "Error: Source directory/file is required." >&2
    show_help
    exit 1
fi
if [ ! -e "$SRC" ]; then
    echo "Error: Source directory/file '$SRC' does not exist." >&2
    exit 1
fi

# Create destination directory if it doesn't exist
mkdir -p "$DEST"

# Define backup tarball file name
BASENAME=$(basename "$SRC")
BACKUP_FILE="$DEST/${BASENAME}_backup_$TIMESTAMP_NAME.tar.gz"


#============================================================
#===================Start backup process=====================
#============================================================

echo "============================================================"
echo "===================Start backup process====================="
echo "============================================================"
echo "Starting backup of '$SRC' to '$BACKUP_FILE'..."
tar -czf "$BACKUP_FILE" -C "$(dirname "$SRC")" "$BASENAME"
PROCESS=$(tar -czf "$BACKUP_FILE" -C "$(dirname "$SRC")" "$BASENAME")

# Log the backup dteails
if $PROCESS; then
    echo "-> Your directory/file has been backed up successfully."
    echo "-> Backup tarball file created at: $BACKUP_FILE"

    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "$(date +'%Y-%m-%d %H:%M:%S') - Backup of '$SRC' created at '$BACKUP_FILE' (Size: $SIZE)" >> "$DEST/backup.log"
    echo "-> Log Updated: $DEST/backup.log"
    fi
else
    echo "Error: Backup failed." >&2
    exit 1
fi

# Display backup details
echo "----------------"
echo "-Backup Details-"
echo "----------------"
echo " Source Directory: $SRC"
echo " Destination Directory: $DEST"
echo " Backup File: $BACKUP_FILE"
echo " Timestamp: $TIMESTAMP"
COUNT=$(find "$DEST" -maxdepth 1 -type f -name "${BASENAME}*" | wc -l)
echo "Backup File Version: $COUNT"
echo "----------------"
echo "----------------"

# Display completion message
echo "============================================================="
echo "===========Backup process completed successfully============="
echo "============================================================="

# Cleanup
unset SRC DEST TIMESTAMP BASENAME BACKUP_FILE VERSION VERSION_NAME

# Exit script
exit 0

# End of backupPuddy-plus script

