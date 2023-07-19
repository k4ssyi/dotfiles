#!/usr/bin/env bash

echo 'check brew command path ....'
# BREW_PATH=$(which brew)
# if [ -n "$BREW_PATH" ]; then
  echo 'setup brew....'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'setup brew.... Done!'
# fi

