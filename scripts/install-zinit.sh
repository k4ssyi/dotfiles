#!/usr/bin/env bash

sh -c "$(curl -fsSL https://git.io/zinit-install)"
source ${HOME}/.zshrc
zinit self-update

