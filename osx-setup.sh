#!/bin/bash
source ./_helpers.sh
set -eux

# terminal
brew install --cask iterm2

# essentials
brew install \
  python3

# unfortunately appears there's too many things reliant on nodejs
brew install node

# misc tools
brew install \
  ripgrep jq autojump bash-completion

# bitwarden cli
brew install bitwarden-cli

# productiviy
brew install --cask \
  rectangle

# neovim
brew install neovim

pip3 install pynvim


copy_dots
update_bashrc

write_file ~/.bash_profile <<"EOF"
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
EOF
