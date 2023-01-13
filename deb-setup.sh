#!/bin/bash
source ./_helpers.sh
set -eux

mkdir -p /usr/local/etc/profile.d
sudo apt update

# terminal
sudo apt-get install -y terminator

# essentials
sudo apt-get install -y \
  curl build-essential ca-certificates xclip python3 python3-pip

# unfortunately appears there's too many things reliant on nodejs
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
sudo corepack enable

# misc tools
sudo apt-get install -y \
 ripgrep jq fd-find autojump bash-completion fzf
cp /usr/share/autojump/autojump.sh /usr/local/etc/profile.d/autojump.sh

# bitwarden cli
sudo npm install -g @bitwarden/cli

# neovim
source /etc/os-release
if [ "$ID" == "ubuntu" ]; then
  dl_gh_latest_release neovim/neovim nvim-linux64.deb
  sudo apt install ./nvim-linux64.deb && rm ./nvim-linux64.deb
elif [ "$ID" == "raspbian" ]; then
  workdir="$WORKSPACE/neovim"
  if [ ! -d "$WORKSPACE/neovim" ]; then
    git clone https://github.com/neovim/neovim.git $workdir
  fi

  pushd "$workdir"
  git fetch --tags --force && git checkout stable

  sudo apt-get install -y \
    ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

  make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr
  sudo make install
  popd

else
  echo "Unable to install neovim: unknown OS type"
  exit 1
fi

pip3 install pynvim

sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --set vim /usr/bin/nvim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --set editor /usr/bin/nvim


sudo apt-get autoremove -y

# keyboard swap caps and escape
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

copy_dots
update_bashrc
