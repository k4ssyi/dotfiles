#!/usr/bin/env bash

# mise設定セットアップスクリプト
# 共通ライブラリを使用してエラーハンドリングと日本語対応を強化

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "mise設定のセットアップを開始します"

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# miseの存在確認
if ! command_exists mise; then
	log_warning "miseがインストールされていません。先にHomebrewパッケージをインストールしてください"
	exit 1
fi

# ツールのインストール
log_step "開発ツールをインストール中..."

# miseは自動的にツールを検出・インストールするため、プラグイン管理は不要
# NOTE: @lts/@latest はインストール時点の最新に解決される
# プロジェクト固有の固定バージョンは .tool-versions で管理すること
tools=(
	"nodejs@lts"
	"python@latest"
	"golang@latest"
	"ruby@latest"
	"pnpm@latest"
)

for tool in "${tools[@]}"; do
	log_info "$tool をインストール中..."
	
	if [[ "$DRYRUN_MODE" == "true" ]]; then
		log_dryrun "ツールインストール: $tool"
	else
		if mise install "$tool"; then
			log_success "$tool をインストールしました"
		else
			log_warning "$tool のインストールに失敗しました"
		fi
	fi
done

# グローバルバージョンの設定
log_step "グローバルバージョンを設定中..."

if [[ "$DRYRUN_MODE" == "true" ]]; then
	log_dryrun "グローバルバージョン設定: nodejs@lts, python@latest"
else
	# ホームディレクトリにグローバル設定のみ
	mise use --global nodejs@lts
	mise use --global python@latest
	log_success "グローバルバージョンを設定しました"
	
	# 従来のバージョンファイル（.nvmrc、.python-versionなど）の自動認識を有効化
	log_step "mise設定を最適化中..."
	mise settings add idiomatic_version_file_enable_tools '["node", "python", "ruby", "golang"]'
	log_success "従来のバージョンファイル自動認識を有効化しました"
	
	log_info "プロジェクト固有の設定は各プロジェクトで.tool-versionsを作成してください"
fi

# mise設定の確認
log_step "mise設定を確認中..."
if [[ "$DRYRUN_MODE" == "true" ]]; then
	log_dryrun "設定確認をスキップ"
else
	log_info "インストール済みツール:"
	mise list || log_warning "mise設定の確認に失敗しました"
fi

log_success "mise設定のセットアップが完了しました"
log_info "新しいシェルセッションで設定が有効になります"

