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
sudo snap install bw

# neovim
dl_gh_latest_release neovim/neovim nvim-linux64.deb
sudo apt install ./nvim-linux64.deb && rm ./nvim-linux64.deb

sudo pip3 install pynvim

sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --set vim /usr/bin/nvim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --set editor /usr/bin/nvim


sudo apt-get autoremove -y

remap_keys
copy_dots
update_bashrc
