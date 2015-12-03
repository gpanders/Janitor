#!/usr/bin/env bash

# Define which folder to clean out
export TARGET_DIR=$HOME/Downloads

# How long should a file be able to live in the folder?
export DAYS_TO_KEEP=30

# Delete this line if you want to hard-delete files instead of moving them to Trash
export TRASH_DIR=$HOME/.Trash/

# Location to store log files, relative to the Janitor directory
export LOG_DIR=logs

function clean() {
    if [ $# -eq 0 ]; then
        exit 1
    fi

    if [ ! -z "$TRASH_DIR" ]; then
        rsync -a "$1" "$TRASH_DIR"
    fi
    rm -rf "$1"

    LOG="$LOG_DIR"/janitor_$(date +"%Y%m%d").log

    if [ ! -e $LOG ]; then
        echo "Files removed from $TARGET_DIR on $(date +%m-%d-%Y):" > "$LOG"
    fi
    echo "${1##*/}" >> "$LOG"
}

export -f clean

find "$TARGET_DIR" -mtime +$DAYS_TO_KEEP -depth 1 -exec bash -c 'clean "$0"' {} \;