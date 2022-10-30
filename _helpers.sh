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
# run cmd in subshell to not mess up any global `set -e`
(
  set +e
  read -r -d '' str
  grep -F "$str" ~/.bashrc
  if [ $? != 0 ]; then
    # add newline
    echo "" >> ~/.bashrc
    echo "$str" >> ~/.bashrc
  fi
)
}

update_bashrc() {
  if [ ! -f ~/.bashrc ]; then
    touch ~/.bashrc
  fi

  write_bashrc <<"EOF"
source ~/.git-prompt.sh
export PS1='\[\e[34m\]\W\[\e[32m\]$(__git_ps1 "[%s]")\[\e[m\]\$ '
EOF

  write_bashrc <<"EOF"
for f in /usr/local/etc/profile.d/*; do source $f; done
EOF

  write_bashrc <<"EOF"
export PATH="$PATH:$HOME/bin"
EOF

  write_bashrc <<"EOF"
# bigger and shared history
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=100000
HISTFILESIZE=100000
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
EOF

  echo "to reload bashrc: source ~/.bashrc"
}

copy_dots() {
  cp -r dots/. ~/
  cp -r scripts/. ~/bin/

  # neovim config
  if ! [ -e ~/.config/nvim ]; then
    git clone https://github.com/chenbh/dotnvim.git ~/.config/nvim
  fi
}
