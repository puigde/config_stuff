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
