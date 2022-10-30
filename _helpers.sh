#!/bin/bash

WORKSPACE="$HOME/workspace"

# example: dl_gh_latest_release neovim/neovim nvim-linux64.deb
dl_gh_latest_release() {
    repo="$1"
    asset="$2"
    url=$(curl -s "https://api.github.com/repos/$repo/releases/latest" | jq -r --arg name "$asset" '.assets[] | select(.name == $name) | .browser_download_url')
    wget -O "$asset" "$url"
}

# remap caps lock -> escape
remap_keys() {
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
}

write_bashrc() {
  read -r -d '' str
  grep "$str" ~/.bashrc
  if [ $? != 0 ]; then
    echo "$str" >> ~/.bashrc
  fi
}

update_bashrc() {
  write_bashrc <<"EOF"
export PATH="$PATH:$HOME/bin"
EOF

  write_bashrc <<"EOF"
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export PS1="\u@\h \[\e[32m\]\w \[\e[91m\]\$(parse_git_branch)\[\e[00m\]$ "
EOF

  write_bashrc <<"EOF"
for file in /usr/local/etc/profile.d/*; do
  source $file
EOF

  # reload bashrc
  if [ -f ~/.bashrc ]; then
      source ~/.bashrc
  fi
}


copy_dots() {
  # copy all the .*
  cp -r dots/. ~/

  # install any custom scripts
  cp -r scripts/. ~/bin/

  # neovim config
  if ! [ -e ~/.config/nvim ]; then
    git clone https://github.com/chenbh/dotnvim.git ~/.config/nvim
  fi
}
