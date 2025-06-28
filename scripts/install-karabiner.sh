#!/usr/bin/env bash

# Karabiner Elements設定セットアップスクリプト
# 共通ライブラリを使用してエラーハンドリングと日本語対応を強化

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "Karabiner Elements設定のセットアップを開始します"

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# Karabiner設定ファイルの存在確認
karabiner_assets_source="$(pwd)/karabiner/assets"
karabiner_config_source="$(pwd)/karabiner/karabiner.json"

if [[ ! -d "$karabiner_assets_source" ]]; then
	handle_error "Karabiner assetsディレクトリが見つかりません: $karabiner_assets_source"
fi

if [[ ! -f "$karabiner_config_source" ]]; then
	handle_error "Karabiner設定ファイルが見つかりません: $karabiner_config_source"
fi

# 既存設定のバックアップ
log_step "既存Karabiner設定のバックアップを作成中..."
create_backup "${HOME}/.config/karabiner"

# Karabiner設定のセットアップ
log_step "Karabiner Elements設定のセットアップ中..."
mkdir -p "${HOME}/.config/karabiner"

create_symlink "$karabiner_assets_source" "${HOME}/.config/karabiner/assets" true
create_symlink "$karabiner_config_source" "${HOME}/.config/karabiner/karabiner.json" true

log_success "Karabiner Elements設定のセットアップが完了しました"
log_info "Karabiner Elementsでアクセシビリティ権限を許可してください"
