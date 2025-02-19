#!/bin/bash

source ./utils.sh
FILES=("tmux.sh" "obsidian.sh" "ghostty.sh")
setup_rc_file "${FILES[@]}"
source_rc_file
update_tmux_config
