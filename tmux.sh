#!/bin/bash

tl() {
    tmux list-sessions
}

ta() {
    if [ -z "$1" ]; then
        tmux new-session
    else
        tmux attach-session -t $1
    fi
}

tk() {
    if [ -z "$1" ]; then
        tmux kill-session
    else
        tmux kill-session -t $1
    fi
}

update_tmux_config() {
    local tmux_config_file="$HOME/.tmux.conf"
    local script_dir="$HOME/Documents/config_stuff"
    if [ -f "$script_dir/tmuxconf" ]; then
        cp "$script_dir/tmuxconf" "$tmux_config_file"
        echo "Updated tmux configuration in $tmux_config_file changes will be active on fresh tmux server"
    else
        echo "Warning: tmuxconf not found in $script_dir"
    fi
}

