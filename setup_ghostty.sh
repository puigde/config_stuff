#!/bin/bash

# Define the source config file (local copy)
LOCAL_CONFIG="ghostty/config"

# Determine the Ghostty config path based on platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS path
    CONFIG_PATH="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
else
    # Linux/XDG path
    CONFIG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/config"
fi

# Ensure the target directory exists
mkdir -p "$(dirname "$CONFIG_PATH")"

# Copy the local config to the correct location
cp "$LOCAL_CONFIG" "$CONFIG_PATH"

# Verify and display success message
if [[ $? -eq 0 ]]; then
    echo "Ghostty configuration updated successfully!"
else
    echo "Failed to update Ghostty configuration."
fi
