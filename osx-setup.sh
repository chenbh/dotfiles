#!/bin/bash
source ./_helpers.sh
set -eux

# terminal
brew install --cask iterm2

# essentials
brew install \
  python3 pip3

# unfortunately appears there's too many things reliant on nodejs
brew install node

# misc tools
brew install \
  ripgrep jq autojump

# bitwarden cli
brew install bitwarden-cli

# productiviy
brew install --cask \
  rectangle sensiblesidebuttons

# neovim
brew install neovim

sudo pip3 install pynvim


copy_dots
update_bashrc
