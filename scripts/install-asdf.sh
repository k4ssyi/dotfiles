#!/usr/bin/env bash

echo 'install asdf plugings.....'

asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin add awscli
asdf plugin add aws-vault
asdf plugin add golang
asdf plugin add python
asdf plugin add ruby
asdf plugin add direnv

# install Nodejs
asdf install nodejs latest
asdf global nodejs latest

# install Python
asdf install python 2.7.18
asdf install python latest
asdf global python latest

# direnv setup
asdf direnv setup --shell zsh --version latest # or bash or fish

echo 'install asdf plugins.... Done!'

