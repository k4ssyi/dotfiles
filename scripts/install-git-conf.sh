#!/usr/bin/env bash

# Git設定セットアップスクリプト
# 共通ライブラリを使用してエラーハンドリングと日本語対応を強化

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "Git設定のセットアップを開始します"

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# Git設定ファイルの存在確認
git_config_source="$(pwd)/git/.gitconfig"
gitignore_source="$(pwd)/git/gitignore_global"

# 既存設定のバックアップ
log_step "既存Git設定のバックアップを作成中..."
create_backup "${HOME}/.gitconfig"
create_backup "${HOME}/.config/git"

# .gitconfigの設定
if [[ -f "$git_config_source" ]]; then
	log_step ".gitconfigのセットアップ中..."
	create_symlink "$git_config_source" "${HOME}/.gitconfig" true
else
	log_warning ".gitconfigファイルが見つかりません: $git_config_source"
	log_info "Git設定は手動で行ってください: git config --global user.name 'Your Name'"
fi

# グローバル gitignore の設定
if [[ -f "$gitignore_source" ]]; then
	log_step "グローバルgitignoreのセットアップ中..."
	mkdir -p "${HOME}/.config/git"
	create_symlink "$gitignore_source" "${HOME}/.config/git/ignore" true
else
	handle_error "gitignore_globalファイルが見つかりません: $gitignore_source"
fi

# Git の実行確認
if command_exists git; then
	git_version=$(git --version | cut -d' ' -f3)
	log_success "Gitが利用可能です: $git_version"

	# 設定確認
	git_user=$(git config --global user.name 2>/dev/null || echo "未設定")
	git_email=$(git config --global user.email 2>/dev/null || echo "未設定")

	log_info "現在のGit設定:"
	log_info "  ユーザー名: $git_user"
	log_info "  メールアドレス: $git_email"

	if [[ "$git_user" == "未設定" || "$git_email" == "未設定" ]]; then
		log_warning "Git のユーザー情報が設定されていません"
		log_info "設定方法:"
		log_info "  git config --global user.name 'Your Name'"
		log_info "  git config --global user.email 'your.email@example.com'"
	fi
else
	log_warning "Gitがインストールされていません。先にHomebrewパッケージをインストールしてください"
fi

log_success "Git設定のセットアップが完了しました"
