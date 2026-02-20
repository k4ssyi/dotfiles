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
setopt SHARE_HISTORY             # セッション間で履歴を共有（INC_APPEND_HISTORYを内包）

# その他の便利オプション
setopt AUTO_CD                   # ディレクトリ名だけでcd
setopt AUTO_PUSHD                # cdで自動的にpushd
setopt PUSHD_IGNORE_DUPS         # 重複するディレクトリをpushdしない
setopt CORRECT                   # コマンドのスペル修正
setopt NO_BEEP                   # ビープ音を無効化

# エディタとツール設定
export EDITOR=nvim
export VISUAL=nvim

# ripgrep設定
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"

# bat設定
export BAT_THEME="Catppuccin Mocha"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# ----------------------------
# FZF設定
# ----------------------------
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_DEFAULT_OPTS=" \
  --height=80% \
  --layout=reverse \
  --border \
  --info=inline \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {}'"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_ALT_C_OPTS="--preview 'lsd --tree --depth 2 {} 2>/dev/null | head -50'"

# エイリアス設定
alias vim="nvim"
alias vi="nvim"

# lsd aliases
alias ls='lsd'
alias l='lsd -l'
alias la='lsd -la'
alias lt='lsd --tree'

# bat aliases（パイプ時は素のcatにフォールバックしてバイナリデータ破損を防止）
cat() {
  if [ -t 1 ] && command -v bat >/dev/null 2>&1; then
    bat --paging=never "$@"
  else
    command cat "$@"
  fi
}

# その他のエイリアス
alias grep='grep --color=auto'
alias history='history -E -i 1'
alias reload='source ~/.zshrc'
alias aider="aider --model gpt-4o --multiline --watch-files --no-auto-commit"
alias update-all='brew update && brew upgrade; mise upgrade; mas upgrade; sheldon lock --update; ~/.tmux/plugins/tpm/bin/update_plugins all'

# ----------------------------
# Sheldon plugin manager
# ----------------------------
# 設定は ~/.config/sheldon にシンボリックリンクで配置（install-zsh-conf.sh参照）
eval "$(sheldon source)"

# 補完システムの初期化
autoload -Uz compinit && compinit

# FZFキーバインド・補完の有効化（Ctrl+T, Ctrl+R, Alt+C）
# compinit後に読み込む（fzf --zsh 内部で compdef を使用するため）
eval "$(fzf --zsh)"

# PATH設定の最適化
typeset -U path  # 重複を自動削除
# HOMEBREW_PREFIX は .zprofile の brew shellenv で設定済み
path=(
    ${HOMEBREW_PREFIX:-/usr/local}/bin
    $path
)
export PATH

# 信頼されたディレクトリ配下でのみ自動activateする
# $HOME/workspace 配下のみ許可（必要に応じて追加）
AUTO_VENV_TRUSTED_DIRS=("$HOME/workspace")

function auto_venv() {
  if [ -e ".venv/bin/activate" ]; then
      local current_dir="$(pwd)"
      local trusted=false
      for dir in "${AUTO_VENV_TRUSTED_DIRS[@]}"; do
          if [[ "$current_dir" == "$dir" || "$current_dir" == "$dir/"* ]]; then
              trusted=true
              break
          fi
      done
      if $trusted; then
          source "${current_dir}/.venv/bin/activate"
          echo "Activated virtual environment in $current_dir"
      fi
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd auto_venv

# 初回読み込み時にも実行
auto_venv

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
