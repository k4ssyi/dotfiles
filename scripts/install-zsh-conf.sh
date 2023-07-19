#!/usr/bin/env bash

echo "setup zsh config"

ln -fsn $(pwd)/zsh/.zshrc ${HOME}/.zshrc
ln -fsn $(pwd)/zsh/.zprofile ${HOME}/.zprofile

