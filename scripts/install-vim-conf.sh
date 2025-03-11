#!/usr/bin/env bash

echo "set nvim"

rm -rf "${HOME}/.config/nvim"
ln -fsn "${PWD}/nvim ${HOME}/.config/nvim"
ln -sf "${HOME}/.config/vscode-nvim/settings.json ${HOME}/Library/Application\ Support/Cursor/User/settings.json"
ln -sf "${HOME}/.config/vscode-nvim/vscode-keybindings.json ${HOME}/Library/Application\ Support/Cursor/User/keybindings.json"
