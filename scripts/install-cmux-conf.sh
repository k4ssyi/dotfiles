#!/usr/bin/env bash

# cmux設定セットアップスクリプト
# 共通ライブラリを使用してエラーハンドリングと日本語対応を強化

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# 単体実行時の --dry-run パース（install.sh 経由では DRYRUN_MODE が継承される）
if [[ "${1:-}" == "--dry-run" || "${1:-}" == "-d" ]]; then
	export DRYRUN_MODE=true
fi

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "cmux設定のセットアップを開始します"

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# cmux設定ファイルの存在確認
cmux_config_source="$(pwd)/cmux/cmux.json"

if [[ ! -f "$cmux_config_source" ]]; then
	handle_error "cmux設定ファイルが見つかりません: $cmux_config_source"
fi

# 既存設定のバックアップ
# NOTE: cmuxは起動時に ~/.config/cmux/cmux.json が無ければテンプレートを再生成する。
#       symlink で存在させておけば上書きされない。
log_step "既存cmux設定のバックアップを作成中..."
create_backup "${HOME}/.config/cmux/cmux.json"

# cmux設定ディレクトリの作成とシンボリックリンク作成
log_step "cmux設定のセットアップ中..."
mkdir -p "${HOME}/.config/cmux"
create_symlink "$cmux_config_source" "${HOME}/.config/cmux/cmux.json" true

# cmuxの実行確認
if command_exists cmux; then
	log_success "cmuxが利用可能です"
	log_info "適用するには 'cmux reload-config' を実行（アプリ再起動不要）"
elif [[ -d "/Applications/cmux.app" ]]; then
	log_success "cmux.appが見つかりました"
	log_info "cmuxを起動すると新しい設定が適用されます"
else
	log_warning "cmuxがインストールされていません。先にcmuxをインストールしてください"
fi

log_success "cmux設定のセットアップが完了しました"
