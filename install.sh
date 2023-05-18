#!/usr/bin/env bash

./scripts/setup-brew.sh

./scripts/install-brew-component.sh
./scripts/setup-chsh.sh

./scripts/install-alacritty.sh
./scripts/uninstall-python27.sh

./scripts/install-enhancd.sh
./scripts/install-bash-conf.sh
./scripts/install-git-conf.sh
./scripts/install-vim-conf.sh
./scripts/install-tmux-conf.sh
./scripts/install-go.sh
./scripts/install-powerline.sh
