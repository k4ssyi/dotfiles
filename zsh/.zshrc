eval "$(starship init zsh)"

export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

### コマンド履歴の管理
HISTFILE=~/.zsh_history
# 重複を記録しない
setopt hist_ignore_dups

# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups

# 余分な空白は詰めて記録
setopt hist_reduce_blanks 

# 開始と終了を記録
setopt EXTENDED_HISTORY

export HISTSIZE=20000
export SAVEHIST=20000
export HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S '

# vim alias
export EDITOR=nvim
alias vim="nvim"

alias ls='lsd'
alias l='lsd -l'
alias ll='lsd -l'
alias la='lsd -la'
alias lt='lsd --tree'
alias grep='grep --color=auto'
alias history='history -E -i 1'
alias aider="aider --model gpt-4.1 --no-auto-commit"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ----------------------------
# Zinit plugins
# ----------------------------

# シンタックスハイライト
zinit light zsh-users/zsh-syntax-highlighting
# 入力補完
zinit light zsh-users/zsh-autosuggestions
# zinit light zsh-users/zsh-completions
zinit light marlonrichert/zsh-autocomplete
# コマンド履歴を検索
zinit light zdharma/history-search-multi-word
zinit light asdf-vm/asdf

## asdf
fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit

export PATH="/opt/homebrew/opt/jpeg/bin:$PATH"
source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"
export PATH="/opt/homebrew/bin:$PATH"

function auto_venv() {
  if [ -e ".venv/bin/activate" ]; then
      source .venv/bin/activate
      echo "Activated virtual environment in $(pwd)"
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd auto_venv

# 初回読み込み時にも実行
auto_venv
