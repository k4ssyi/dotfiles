#!/usr/bin/env bash

# Starship設定セットアップスクリプト
# 共通ライブラリを使用してエラーハンドリングと日本語対応を強化

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "Starship設定のセットアップを開始します"

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# Starship設定ファイルの存在確認
starship_config_source="$(pwd)/starship.toml"

if [[ ! -f "$starship_config_source" ]]; then
	handle_error "Starship設定ファイルが見つかりません: $starship_config_source"
fi

# 既存設定のバックアップ
log_step "既存Starship設定のバックアップを作成中..."
create_backup "${HOME}/.config/starship.toml"

# Starship設定のセットアップ
log_step "Starship設定のセットアップ中..."
mkdir -p "${HOME}/.config"
create_symlink "$starship_config_source" "${HOME}/.config/starship.toml" true

# Starshipの実行確認
if command_exists starship; then
	starship_version=$(starship --version | cut -d' ' -f2)
	log_success "Starshipが利用可能です: $starship_version"
	log_info "新しいターミナルセッションでStarshipプロンプトが適用されます"
else
	log_warning "Starshipがインストールされていません。先にHomebrewパッケージをインストールしてください"
fi

log_success "Starship設定のセットアップが完了しました"
