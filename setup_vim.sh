#!/bin/bash

# Disable press and hold for key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Copy vimrc to home directory
cp .vimrc $HOME/.vimrc
