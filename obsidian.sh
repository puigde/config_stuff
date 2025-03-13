#!/bin/bash

# Define OBSIDIAN_PATH variable
OBSIDIAN_PATH="$HOME/Documents/obsfiles/Obsidian Vault/"

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

om() {
    if [ -z "$1" ]; then
        oo || return 1
        cd "cache" || { echo "Error: Unable to navigate to cache directory."; return 1; }
        cd "meetings" || { echo "Error: Unable to navigate to meetings directory."; return 1; }
        nvim "$(date +%Y-%m-%d).md"
    else
        oo || return 1
        cd "Learns/Projects/Active/$1" || { echo "Error: Unable to navigate to project directory."; return 1; }
        if [ ! -d "meetings" ]; then
            mkdir "meetings" || { echo "Error: Unable to create meetings directory."; return 1; }
        fi
        cd "meetings" || { echo "Error: Unable to navigate to meetings directory."; return 1; }
        nvim "$(date +%Y-%m-%d).md"
    fi
}

ow() {
    oo || return 1
    cd "cache" || { echo "Error: Unable to navigate to cache directory."; return 1; }
    cd "../Learns/Writes" || { echo "Error: Unable to navigate to meetings directory."; return 1; }
    nvim "$(date +%Y-%m-%d).md"
}

oa() {
    oo || return 1
    cd "Learns/Reads/Academic" || { echo "Error unable to navigate to project directory."; return 1;}
}

og() {
    # Check if search term is provided
    if [ -z "$1" ]; then
        echo "Error: Please provide a search term."
        echo "Usage: og <search_term> [subdirectory]"
        return 1
    fi

    search_term="$1"
    
    # Start in the Obsidian vault root directory
    current_dir=$(pwd)
    oo || return 1
    
    # If subdirectory is specified, try to navigate to it
    if [ -n "$2" ]; then
        if [ -d "$2" ]; then
            cd "$2" || { echo "Error: Unable to navigate to specified subdirectory."; cd "$current_dir"; return 1; }
        else
            echo "Warning: Subdirectory not found. Searching in root directory instead."
        fi
    fi
    
    echo "Searching for: '$search_term' in $(pwd)"
    echo "----------------------------------------"
    
    # Perform recursive grep search with:
    # -i: case insensitive
    # -n: show line numbers
    # -r: recursive
    # --include="*.md": only search markdown files
    # --color=always: highlight matches
    grep -i -n -r --include="*.md" --color=always "$search_term" .
    
    # Return to original directory
    cd "$current_dir"
}

