#!/usr/bin/env bash

# Hammerspoon設定セットアップスクリプト
# 共通ライブラリを使用してエラーハンドリングと日本語対応を強化

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "Hammerspoon設定のセットアップを開始します"

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# Hammerspoon設定ファイルの存在確認
hammerspoon_source="$(pwd)/hammerspoon"

if [[ ! -d "$hammerspoon_source" ]]; then
	handle_error "Hammerspoon設定ディレクトリが見つかりません: $hammerspoon_source"
fi

# 既存設定のバックアップ
log_step "既存Hammerspoon設定のバックアップを作成中..."
create_backup "${HOME}/.hammerspoon"

# Hammerspoon設定のセットアップ
log_step "Hammerspoon設定のセットアップ中..."
create_symlink "$hammerspoon_source" "${HOME}/.hammerspoon" true

log_success "Hammerspoon設定のセットアップが完了しました"
log_info "Hammerspoonを再起動すると新しい設定が適用されます"
