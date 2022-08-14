#!/bin/bash

set -eux

VIM_CONFIG="https://github.com/chenbh/dotnvim.git"
WORKSPACE="$HOME/workspace"

function gimme() {
    sudo apt-get install -y "$@"
}

# copy all the .*
cp -r dots/. ~/

# install any custom scripts
cp -r scripts/. ~/bin/

sudo apt update

# essentials
gimme curl build-essential ca-certificates xclip python3 python3-pip

# misc tools
gimme ripgrep jq fd-find

# autojump
gimme autojump
sudo mkdir -p /usr/local/etc/profile.d
sudo cp /usr/share/autojump/autojump.sh /usr/local/etc/profile.d/autojump.sh

# terminal
gimme terminator


# bitwarden cli
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g @bitwarden/cli


# neovim
# prereqs
gimme ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

if ! [ -d "$WORKSPACE/neovim" ]; then
  git clone https://github.com/neovim/neovim.git "$WORKSPACE/neovim"
fi

cd "$WORKSPACE/neovim" && git checkout stable
make CMAKE_BUILD_TYPE=Release
sudo make install
make clean

sudo update-alternatives --install /usr/bin/vim vim /usr/local/bin/nvim 60
sudo update-alternatives --set vim /usr/local/bin/nvim
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/nvim 60
sudo update-alternatives --set editor /usr/local/bin/nvim

# plugins
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
