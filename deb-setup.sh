#!/bin/bash

set -eux

VIM_CONFIG="https://github.com/chenbh/dotnvim.git"

function gimme() {
    sudo apt-get install -y "$@"
}

function getme() {
    sudo snap install "$@"
}

# copy all the .*
cp -r dots/. ~/

# install any custom scripts
cp -r scripts/. ~/bin/

sudo apt update

# essentials
gimme curl build-essential ca-certificates xclip

gimme git

# misc tools
gimme silversearcher-ag

gimme jq

# autojump
gimme autojump
grep "source /usr/share/autojump/autojump.sh" ~/.bashrc
if [ $? != 0 ]; then
  echo "source /usr/share/autojump/autojump.sh" >> ~/.bashrc
fi

# terminal
gimme terminator

# bitwarden cli
getme bw

# setup vim
gimme neovim

sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --set vi /usr/bin/nvim
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --set vim /usr/bin/nvim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --set editor /usr/bin/nvim

# neovim plugins
gimme python3 python3-pip
sudo pip3 install pynvim

if ! [ -e ~/.config/nvim ]; then
  git clone $VIM_CONFIG ~/.config/nvim --recursive
fi

# reload bashrc
source ~/.bashrc
