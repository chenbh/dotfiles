#!/bin/bash

set -eux

VIM_CONFIG="https://github.com/chenbh/dotnvim.git"

function gimme() {
    brew install "$@"
}

function getme() {
    brew cask install "$@"
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

# window snapping
getme rectangle

# neovim plugins
gimme python3 pip3
sudo pip3 install pynvim

if ! [ -e ~/.config/nvim ]; then
  git clone $VIM_CONFIG ~/.config/nvim --recursive
fi

# reload bashrc
source ~/.bashrc

echo "Additional installations"
# mouse4/mouse5 -> backward/forward
echo "https://github.com/archagon/sensible-side-buttons/releases"
