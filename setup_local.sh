#!/bin/bash

source ./utils.sh
FILES=("tmux.sh" "obsidian.sh" "ghostty.sh" "git.sh" "prompt.sh")
setup_rc_file "${FILES[@]}"

# Source the rc file and update tmux config in the appropriate shell
if [[ "$OSTYPE" == *"darwin"* ]]; then
    zsh -c "source ~/.zshrc && update_tmux_config"
else
    bash -c "source ~/.bashrc && update_tmux_config"
fi
