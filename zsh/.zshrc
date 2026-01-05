eval "$(starship init zsh)"

export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

### zsh オプション設定
# 履歴管理
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S '

# 履歴オプション
setopt EXTENDED_HISTORY          # 実行時刻とコマンド実行時間を記録
setopt HIST_EXPIRE_DUPS_FIRST    # 履歴削除時に重複を優先削除
setopt HIST_IGNORE_ALL_DUPS      # 重複コマンドは古いものを削除
setopt HIST_IGNORE_DUPS          # 直前と同じコマンドは記録しない
setopt HIST_IGNORE_SPACE         # スペースから始まるコマンドは記録しない
setopt HIST_REDUCE_BLANKS        # 余分な空白を削除
setopt HIST_SAVE_NO_DUPS         # 重複を保存しない
setopt HIST_VERIFY               # 履歴展開時に確認
setopt INC_APPEND_HISTORY        # リアルタイムで履歴を追加
setopt SHARE_HISTORY             # セッション間で履歴を共有

# その他の便利オプション
setopt AUTO_CD                   # ディレクトリ名だけでcd
setopt AUTO_PUSHD                # cdで自動的にpushd
setopt PUSHD_IGNORE_DUPS         # 重複するディレクトリをpushdしない
setopt CORRECT                   # コマンドのスペル修正
setopt NO_BEEP                   # ビープ音を無効化

# エディタとツール設定
export EDITOR=nvim
export VISUAL=nvim

# エイリアス設定
alias vim="nvim"
alias vi="nvim"

# lsd aliases
alias ls='lsd'
alias l='lsd -l'
alias ll='lsd -l'
alias la='lsd -la'
alias lt='lsd --tree'

# その他のエイリアス
alias grep='grep --color=auto'
alias history='history -E -i 1'
alias reload='source ~/.zshrc'
alias aider="aider --model gpt-5 --multiline --watch-files --no-auto-commit --read ~/workspace/dotfiles/ai_role.md"

# ----------------------------
# Sheldon plugin manager
# ----------------------------
# 設定ファイルパスを明示的に指定
export SHELDON_CONFIG_DIR="$HOME/workspace/dotfiles/zsh/sheldon"
eval "$(sheldon source)"

# ----------------------------
# mise (version manager)
# ----------------------------
# miseの初期化（Node.js、Python、Go、Rubyなどのバージョン管理）
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

## asdf completion setup
fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit

# PATH設定の最適化
typeset -U path  # 重複を自動削除
path=(
    /opt/homebrew/bin
    /opt/homebrew/opt/jpeg/bin
    $path
)
export PATH

# asdf-direnv integration
if [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc" ]]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"
fi

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

# nodenvの初期化（インストールされている場合のみ）
if command -v nodenv >/dev/null 2>&1; then
  eval "$(nodenv init -)"
fi

# ----------------------------
# tmux自動起動設定
# ----------------------------
# tmuxがインストールされていて、かつtmuxセッション内でない場合にのみ自動起動
if command -v tmux >/dev/null 2>&1 && [ -z "$TMUX" ]; then
  # 既存のtmuxセッションがある場合はアタッチ、ない場合は新規作成
  if tmux has-session 2>/dev/null; then
    exec tmux attach
  else
    exec tmux new-session
  fi
fi
