#!/usr/bin/env bash

echo 'install asdf plugings.....'

asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin add awscli
asdf plugin add aws-vault
asdf plugin add golang
asdf plugin add python
asdf plugin add ruby

# install Nodejs
asdf install nodejs latest
asdf global nodejs latest

# install Python
asdf install python 2.7.18
asdf install python latest
asdf global python latest

echo 'install asdf plugins.... Done!'

