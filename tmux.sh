#!/bin/bash

tl() {
    tmux list-sessions
}

ta() {
    if [ -z "$1"]; then
        tmux new-session 
    else
        tmux new-session -t $1
    fi
}

tk() {
    if [ -z "$1"]; then
        tmux kill-session
    else
        tmux kill-session -t $1
    fi
}

tmux_config_content=$(cat <<EOF
set-option -sg escape-time 10
set-option -g focus-events on
set -g prefix \`
unbind C-b
bind \` send-prefix
EOF
)
tmux_config_file="$HOME/.tmux.conf"
echo "$tmux_config_content" > "$tmux_config_file"
echo "Updated tmux configuration in $tmux_config_file"
