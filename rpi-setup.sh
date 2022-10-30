#!/bin/bash
source ./_helpers.sh
set -eux

sudo apt update

# terminal
sudo apt-get install -y terminator

# essentials
sudo apt-get install -y \
  curl build-essential ca-certificates xclip python3 python3-pip

# misc tools
sudo apt-get install -y \
  ripgrep jq fd-find autojump

sudo mkdir -p /usr/local/etc/profile.d
sudo cp /usr/share/autojump/autojump.sh /usr/local/etc/profile.d/autojump.sh

# bitwarden cli
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y \
  nodejs
sudo npm install -g @bitwarden/cli


# neovim
sudo apt-get install -y \
  ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

if ! [ -d "$WORKSPACE/neovim" ]; then
  git clone https://github.com/neovim/neovim.git "$WORKSPACE/neovim"
fi

cd "$WORKSPACE/neovim" && git checkout stable
make CMAKE_BUILD_TYPE=Release
sudo make install
make clean

sudo pip3 install pynvim

sudo update-alternatives --install /usr/bin/vim vim /usr/local/bin/nvim 60
sudo update-alternatives --set vim /usr/local/bin/nvim
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/nvim 60
sudo update-alternatives --set editor /usr/local/bin/nvim


sudo apt-get autoremove -y

remap_keys
copy_dots
update_bashrc
