#!/bin/bash

changetheme() {
    # Determine the Ghostty config path based on platform
    local CONFIG_PATH
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS path
        CONFIG_PATH="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
    else
        # Linux/XDG path
        CONFIG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/config"
    fi
    
    # Read current colors
    local current_fg=$(grep "^foreground = " "$CONFIG_PATH" | cut -d'#' -f2)
    local current_bg=$(grep "^background = " "$CONFIG_PATH" | cut -d'#' -f2)
    
    # If colors are not found, use defaults
    if [ -z "$current_fg" ]; then 
        echo "No foreground color found, using default: ffffff"
        current_fg="ffffff"
    fi
    if [ -z "$current_bg" ]; then
        echo "No background color found, using default: 000000" 
        current_bg="000000"
    fi
    
    # Create temporary file
    local temp_file=$(mktemp)
    
    # Read the file line by line and swap colors
    while IFS= read -r line; do
        if [[ $line == foreground* ]]; then
            echo "foreground = #$current_bg"
        elif [[ $line == background* && ! $line == *opacity* ]]; then
            echo "background = #$current_fg"
        else
            echo "$line"
        fi
    done < "$CONFIG_PATH" > "$temp_file"
    
    # Move temporary file to config location
    mv "$temp_file" "$CONFIG_PATH"
    
    echo "Theme colors flipped successfully!"
    echo "Foreground #$current_fg -> #$current_bg"
    echo "Background #$current_bg -> #$current_fg"
    
    # Show reload instruction
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "\nPress Cmd+Shift+, to reload config"
    else
        echo -e "\nPress Ctrl+Shift+, to reload config"
    fi
} 