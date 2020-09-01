#!/bin/bash

set -eux

VIM_CONFIG="https://github.com/chenbh/dotnvim.git"

function gimme() {
    brew install "$@"
}

# copy all the .*
cp -r dots/. ~/

# install any custom scripts
cp -r scripts/. ~/bin/

gimme the_silver_searcher

gimme jq

gimme autojump

gimme neovim

gimme bitwarden-cli

# neovim plugins
gimme python3 pip3
sudo pip3 install pynvim

if ! [ -e ~/.config/nvim ]; then
  git clone $VIM_CONFIG ~/.config/nvim --recursive
fi

# reload bashrc
source ~/.bashrc

