#!/usr/bin/env bash

echo 'install brew components.....'

# for Mac (default zsh)
eval "$(/opt/homebrew/bin/brew shellenv)"

brew update && brew upgrade

brew install git vim neovim tmux direnv jq wget ghq tree coreutils curl gpg gawk mas reattach-to-user-namespace lsd starship ripgrep
brew install --cask google-chrome vivaldi slack notion gyazo visual-studio-code figma bitwarden clipy appcleaner kindle postman discord zoom spotify karabiner-elements logi-options-plus hammerspoon alacritty dbeaver-community docker

# LINE
brew install mas
mas install 539883307

# font
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font

echo 'install brew componets.... Done!'

