#!/bin/bash
cp .vimrc ~/.vimrc
rm -rf ~/.config/nvim
cp -r nvim ~/.config/nvim
