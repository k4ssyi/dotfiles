#!/usr/bin/env bash

echo "setup .gitconfig"
ln -fsn $(pwd)/git/.gitconfig ${HOME}/.gitconfig
ln -fsn $(pwd)/git/gitignore_global ${HOME}/.config/git/ignore

