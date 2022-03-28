#!/bin/bash

set -ux

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
gimme curl build-essential ca-certificates xclip python3 python3-pip

# misc tools
gimme silversearcher-ag jq

# autojump
gimme autojump
sudo mkdir -p /usr/local/etc/profile.d
sudo cp /usr/share/autojump/autojump.sh /usr/local/etc/profile.d/autojump.sh

# terminal
gimme terminator

# bitwarden cli
getme bw

# use neovim dev builds
wget -O nvim https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
install nvim ~/bin/ && rm nvim

sudo update-alternatives --install /usr/bin/vim vim /home/user/bin/nvim 60
sudo update-alternatives --set vim /home/user/bin/nvim
sudo update-alternatives --install /usr/bin/editor editor /home/user/bin/nvim 60
sudo update-alternatives --set editor /home/user/bin/nvim

# neovim plugins
sudo pip3 install pynvim

if ! [ -e ~/.config/nvim ]; then
  git clone $VIM_CONFIG ~/.config/nvim --recursive
fi


# remap caps lock -> escape
sudo cat > /tmp/keyboard <<EOF
# KEYBOARD CONFIGURATION FILE

# Consult the keyboard(5) manual page.

XKBMODEL="pc105"
XKBLAYOUT="us"
XKBVARIANT=""
XKBOPTIONS="caps:escape"

BACKSPACE="guess"
EOF

sudo mv /tmp/keyboard /etc/default/keyboard

sudo apt-get autoremove -y

# reload bashrc
source ~/.bash_profile
