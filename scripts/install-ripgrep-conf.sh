#!/usr/bin/env bash

# ripgrep設定セットアップスクリプト
# ripgrepの設定ファイルをシンボリックリンクで配置

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "ripgrep設定のセットアップを開始します"

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# ripgrep設定ファイルの存在確認
ripgrep_source="$(pwd)/ripgrep/config"
ripgrep_target="${HOME}/.config/ripgrep/config"

if [[ ! -f "$ripgrep_source" ]]; then
	handle_error "ripgrep設定ファイルが見つかりません: $ripgrep_source"
fi

# 既存設定のバックアップ
log_step "既存ripgrep設定のバックアップを作成中..."
create_backup "$ripgrep_target"

# ripgrep設定のセットアップ
log_step "ripgrep設定のセットアップ中..."
mkdir -p "${HOME}/.config/ripgrep"
create_symlink "$ripgrep_source" "$ripgrep_target" true

# ripgrepの実行確認
if command_exists rg; then
	rg_version=$(rg --version | head -1)
	log_success "ripgrepが利用可能です: $rg_version"
else
	log_warning "ripgrepがインストールされていません。先にHomebrewパッケージをインストールしてください"
fi

log_success "ripgrep設定のセットアップが完了しました"
