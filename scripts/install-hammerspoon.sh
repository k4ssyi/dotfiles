#!/usr/bin/env bash

echo "setup hammerspoon config"

rm -rf ${HOME}/.hammerspoon
ln -fsn ${PWD}/hammerspoon/.hammerspoon ${HOME}/.hammerspoon

