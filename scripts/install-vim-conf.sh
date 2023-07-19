#!/usr/bin/env bash

echo "set nvim"

rm -rf ${HOME}/.config/nvim
ln -fsn ${PWD}/nvim ${HOME}/.config/nvim
