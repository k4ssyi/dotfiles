#!/usr/bin/env bash

echo 'install karabiner settings.....'

rm -rf ${HOME}/.config/karabiner/assets

ln -fsn ${PWD}/karabiner/assets ${HOME}/.config/karabiner/assets
ln -fsn ${PWD}/karabiner/karabiner.json ${HOME}/.config/karabiner/karabiner.json

