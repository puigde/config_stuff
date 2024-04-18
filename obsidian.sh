#!/bin/bash

# Define OBSIDIAN_PATH variable
OBSIDIAN_PATH="/Users/polpuigdemont/Documents/Obsidian Vault/"

# Define function to navigate to the Obsidian Vault directory
oo() {
    cd "$OBSIDIAN_PATH" || { echo "Error: Unable to navigate to Obsidian Vault directory."; return 1; }
}

od() {
    if [ -z "$1" ]; then
        year=$(date +%Y)
        month=$(date +%m)
        day=$(date +%d)
    else
        year=$(echo "$1" | cut -d'-' -f1)
        month=$(echo "$1" | cut -d'-' -f2)
        day=$(echo "$1" | cut -d'-' -f3)
    fi
    oo || return 1
    cd "Days" || { echo "Error: Unable to navigate to Days directory."; return 1; }
    cd "$year" || { echo "Error: Unable to navigate to year directory."; return 1; }
    cd "$month" || { echo "Error: Unable to navigate to month directory."; return 1; }
    nvim "$year-$month-$day.md"
}
