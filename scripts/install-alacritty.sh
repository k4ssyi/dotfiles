#!/usr/bin/env bash

# Alacritty設定セットアップスクリプト
# 共通ライブラリを使用してエラーハンドリングと日本語対応を強化

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "Alacritty設定のセットアップを開始します"

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# Alacritty設定ファイルの存在確認
alacritty_config_source="$(pwd)/alacritty/alacritty.toml"

if [[ ! -f "$alacritty_config_source" ]]; then
	handle_error "Alacritty設定ファイルが見つかりません: $alacritty_config_source"
fi

# 既存設定のバックアップ
log_step "既存Alacritty設定のバックアップを作成中..."
create_backup "${HOME}/.config/alacritty"

# Alacritty設定ディレクトリの作成とシンボリックリンク作成
log_step "Alacritty設定のセットアップ中..."
mkdir -p "${HOME}/.config/alacritty"
create_symlink "$alacritty_config_source" "${HOME}/.config/alacritty/alacritty.toml" true

# Alacrittyの実行確認
if command_exists alacritty; then
	alacritty_version=$(alacritty --version | cut -d' ' -f2)
	log_success "Alacrittyが利用可能です: $alacritty_version"
	log_info "Alacrittyを再起動すると新しい設定が適用されます"
else
	log_warning "Alacrittyがインストールされていません。先にHomebrewパッケージをインストールしてください"
fi

log_success "Alacritty設定のセットアップが完了しました"
