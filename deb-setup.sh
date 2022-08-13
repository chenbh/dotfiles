#!/bin/bash

set -ux

VIM_CONFIG="https://github.com/chenbh/dotnvim.git"

gimme() {
    sudo apt-get install -y "$@"
}

getme() {
    sudo snap install "$@"
}

update_rc() {
  read -r -d '' str
  grep "$str" ~/.bashrc
  if [ $? != 0 ]; then
    echo "source /usr/share/autojump/autojump.bash" >> ~/.bashrc
  fi
}

# copy all the .*
cp -r dots/. ~/

# install any custom scripts
cp -r scripts/. ~/bin/

sudo apt update

# essentials
gimme curl build-essential ca-certificates xclip python3 python3-pip

# misc tools
gimme ripgrep jq

# autojump
gimme autojump
update_rc "source /usr/share/autojump/autojump.bash"

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
cat | sudo tee /etc/default/keyboard <<EOF
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

update_rc <<"EOF"
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export PS1="\u@\h \[\e[32m\]\w \[\e[91m\]\$(parse_git_branch)\[\e[00m\]$ "
EOF


update_rc <<"EOF"
[[ -r "/usr/local/etc/profile.d/autojump.sh" ]] && . "/usr/local/etc/profile.d/autojump.sh"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
EOF

# reload bashrc
source ~/.bash_profile
