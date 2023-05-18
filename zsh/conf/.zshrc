#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

### asdf ###
. /opt/homebrew/opt/asdf/libexec/asdf.sh

alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias ls="lsd"

export ANDROID_HOME=/Users/pc-017/Library/Android/sdk

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border \
--preview-window 'right:50%' \
--bind 'ctrl-/:change-preview-window(80%|hidden|)' \
--bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'"

