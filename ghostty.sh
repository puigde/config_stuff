#!/bin/bash

changetheme() {
    local CONFIG_PATH
    if [[ "$OSTYPE" == "darwin"* ]]; then
        CONFIG_PATH="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
    else
        CONFIG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/config"
    fi

    local fg bg desc
    case "$1" in
        d) fg="ffffff"; bg="000000"; desc="dark mode (white on black)" ;;
        w) fg="000000"; bg="ffffff"; desc="white mode (black on white)" ;;
        c) fg="000000"; bg="F0EEE4"; desc="cream mode (black on cream)" ;;
        *)
            echo "Available themes:"
            echo "  c - cream mode (black on cream)"
            echo "  d - dark mode (white on black)"
            echo "  w - white mode (black on white)"
            return
            ;;
    esac

    local temp_file=$(mktemp)
    while IFS= read -r line; do
        if [[ $line == foreground* ]]; then
            echo "foreground = #$fg"
        elif [[ $line == background* && ! $line == *opacity* ]]; then
            echo "background = #$bg"
        else
            echo "$line"
        fi
    done < "$CONFIG_PATH" > "$temp_file"

    mv "$temp_file" "$CONFIG_PATH"
    echo "Applied theme '$1': $desc"
    [[ "$OSTYPE" == "darwin"* ]] && echo "Press Cmd+Shift+, to reload" || echo "Press Ctrl+Shift+, to reload"
} 