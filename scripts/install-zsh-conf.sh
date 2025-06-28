#!/usr/bin/env bash

# zsh・Sheldon設定セットアップスクリプト
# zsh設定とSheldonプラグインマネージャーを統合設定
# 共通ライブラリを使用してエラーハンドリングと日本語対応を強化

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "zsh・Sheldon設定のセットアップを開始します"

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# 既存設定のバックアップ
log_step "既存設定のバックアップを作成中..."
create_backup "${HOME}/.zshrc"
create_backup "${HOME}/.zprofile"
create_backup "${HOME}/.config/sheldon"

# zsh設定ファイルのシンボリックリンク作成
log_step "zsh設定ファイルのシンボリックリンクを作成中..."

# .zshrcのリンク作成
zshrc_source="$(pwd)/zsh/.zshrc"
if [[ -f "$zshrc_source" ]]; then
	create_symlink "$zshrc_source" "${HOME}/.zshrc" true
else
	handle_error ".zshrcファイルが見つかりません: $zshrc_source"
fi

# .zprofileのリンク作成（存在する場合のみ）
zprofile_source="$(pwd)/zsh/.zprofile"
if [[ -f "$zprofile_source" ]]; then
	create_symlink "$zprofile_source" "${HOME}/.zprofile" true
else
	log_info ".zprofileファイルは存在しないため、スキップします"
fi

# Sheldon設定ディレクトリのシンボリックリンク作成
log_step "Sheldon設定のセットアップ中..."
sheldon_source="$(pwd)/zsh/sheldon"
if [[ -d "$sheldon_source" ]]; then
	mkdir -p ~/.config
	create_symlink "$sheldon_source" "${HOME}/.config/sheldon" true

	# Sheldonがインストールされている場合、プラグインの初期化
	if command_exists sheldon; then
		log_step "Sheldonプラグインの初期化中..."
		if measure_time sheldon lock --update; then
			log_success "Sheldonプラグインの初期化が完了しました"

			# プラグイン一覧の表示
			log_info "インストール済みプラグイン:"
			if sheldon list &>/dev/null; then
				sheldon list | while read -r line; do
					log_info "  - $line"
				done
			fi
		else
			log_warning "Sheldonプラグインの初期化に失敗しましたが、継続します"
		fi
	else
		log_warning "Sheldonがインストールされていません。先にHomebrewパッケージをインストールしてください"
	fi
else
	handle_error "Sheldon設定ディレクトリが見つかりません: $sheldon_source"
fi

# zshがデフォルトシェルでない場合の警告
if [[ "$SHELL" != "$(command -v zsh)" ]]; then
	log_warning "現在のデフォルトシェルはzshではありません"
	log_info "zshをデフォルトシェルにするには: chsh -s $(command -v zsh)"
fi

log_success "zsh・Sheldon設定のセットアップが完了しました"
log_info "設定を反映するには新しいターミナルを開くか、'source ~/.zshrc' を実行してください"
log_info "次回のzsh起動時からSheldonプラグインが有効になります"
