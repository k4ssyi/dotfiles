#!/usr/bin/env bash

echo "setup .tmux.conf"
ln -fsn $(pwd)/tmux/.tmux.conf ${HOME}/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm

tmux source ${HOME}/.tmux.conf

