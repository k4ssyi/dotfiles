#!/usr/bin/env bash

# Ghostty設定セットアップスクリプト
# 共通ライブラリを使用してエラーハンドリングと日本語対応を強化

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "Ghostty設定のセットアップを開始します"

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# Ghostty設定ファイルの存在確認
ghostty_config_source="$(pwd)/ghostty/config"

if [[ ! -f "$ghostty_config_source" ]]; then
	handle_error "Ghostty設定ファイルが見つかりません: $ghostty_config_source"
fi

# 既存設定のバックアップ
log_step "既存Ghostty設定のバックアップを作成中..."
create_backup "${HOME}/.config/ghostty"

# Ghostty設定ディレクトリの作成とシンボリックリンク作成
log_step "Ghostty設定のセットアップ中..."
mkdir -p "${HOME}/.config/ghostty"
create_symlink "$ghostty_config_source" "${HOME}/.config/ghostty/config" true

# Ghosttyの実行確認
if command_exists ghostty; then
	ghostty_version=$(ghostty --version 2>/dev/null || echo "unknown")
	log_success "Ghosttyが利用可能です: $ghostty_version"
	log_info "Ghosttyを再起動すると新しい設定が適用されます"
elif [[ -d "/Applications/Ghostty.app" ]]; then
	log_success "Ghostty.appが見つかりました"
	log_info "Ghosttyを起動すると新しい設定が適用されます"
else
	log_warning "Ghosttyがインストールされていません。先にHomebrewパッケージをインストールしてください"
fi

log_success "Ghostty設定のセットアップが完了しました"
