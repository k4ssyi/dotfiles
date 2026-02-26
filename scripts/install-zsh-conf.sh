#!/usr/bin/env bash

# zsh・Sheldon設定セットアップスクリプト
# zsh設定とSheldonプラグインマネージャーを統合設定
# 共通ライブラリを使用してエラーハンドリングと日本語対応を強化

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_step "zsh・Sheldon設定セットアップ"

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# Homebrewの初期化
init_homebrew

# ----------------------------
# zsh設定のシンボリックリンク
# ----------------------------
log_step "zsh設定をセットアップ中..."

zsh_source="$(pwd)/zsh"
if [[ -d "$zsh_source" ]]; then
	create_symlink "$zsh_source/.zshrc" "$HOME/.zshrc"
	create_symlink "$zsh_source/.zprofile" "$HOME/.zprofile"
	log_success "zsh設定のシンボリックリンクを作成しました"
else
	handle_error "zsh設定ディレクトリが見つかりません: $zsh_source"
fi

# ----------------------------
# Sheldonプラグインマネージャーの設定
# ----------------------------
log_step "Sheldonプラグインマネージャーを設定中..."

sheldon_source="$(pwd)/zsh/sheldon"
if [[ -d "$sheldon_source" ]]; then
	sheldon_config_dir="$HOME/.config/sheldon"

	if command_exists sheldon; then
		mkdir -p "$sheldon_config_dir"
		create_symlink "$sheldon_source/plugins.toml" "$sheldon_config_dir/plugins.toml"
		log_success "Sheldon設定をセットアップしました"

		# Sheldonプラグインのロック（初回セットアップ時）
		log_step "Sheldonプラグインをロック中..."
		if [[ "$DRYRUN_MODE" == "true" ]]; then
			log_dryrun "sheldon lock"
		else
			if sheldon lock; then
				log_success "Sheldonプラグインのロックが完了しました"
			else
				log_warning "Sheldonプラグインのロックに失敗しました。次回のシェル起動時に自動的にインストールされます"
			fi
		fi
	else
		log_warning "Sheldonがインストールされていません。先にHomebrewパッケージをインストールしてください"
	fi
else
	handle_error "Sheldon設定ディレクトリが見つかりません: $sheldon_source"
fi

# Homebrew版zshをログインシェルに設定
_brew_zsh="$(get_homebrew_prefix)/bin/zsh"
if [[ -x "$_brew_zsh" ]]; then
	if [[ "$SHELL" != "$_brew_zsh" ]]; then
		log_info "現在のログインシェル: $SHELL"
		log_info "Homebrew版zsh: $_brew_zsh"
		if [[ "$DRYRUN_MODE" == "true" ]]; then
			# dryrun時は対話プロンプトをスキップし、実行予定の操作をログ出力
			if ! grep -qF "$_brew_zsh" /etc/shells; then
				log_dryrun "echo '$_brew_zsh' | sudo tee -a /etc/shells"
			fi
			log_dryrun "chsh -s $_brew_zsh"
		else
			read -rp "ログインシェルをHomebrew版zshに切り替えますか？ [y/N] " _answer
			if [[ "$_answer" =~ ^[Yy]$ ]]; then
				# /etc/shells に未登録なら追加（chsh に必要）
				_can_chsh=true
				if ! grep -qF "$_brew_zsh" /etc/shells; then
					log_step "Homebrew版zshを /etc/shells に登録中（sudo が必要です）..."
					if ! echo "$_brew_zsh" | sudo tee -a /etc/shells >/dev/null; then
						log_warning "/etc/shells への書き込みに失敗しました。ログインシェルの切り替えをスキップします"
						log_info "手動で切り替える場合: chsh -s $_brew_zsh"
						_can_chsh=false
					else
						log_success "/etc/shells に $_brew_zsh を追加しました"
					fi
				fi
				if [[ "$_can_chsh" == "true" ]]; then
					log_step "ログインシェルを切り替え中..."
					if chsh -s "$_brew_zsh"; then
						log_success "ログインシェルを $_brew_zsh に設定しました"
					else
						log_warning "ログインシェルの変更に失敗しました"
						log_info "手動で切り替える場合: chsh -s $_brew_zsh"
					fi
				fi
				unset _can_chsh
			else
				log_info "ログインシェルの切り替えをスキップしました"
				log_info "手動で切り替える場合: chsh -s $_brew_zsh"
			fi
			unset _answer
		fi
	else
		log_info "ログインシェルは既にHomebrew版zshです"
	fi
else
	log_warning "Homebrew版zshが見つかりません。先にHomebrewパッケージをインストールしてください"
	log_info "インストール後に再実行するか、手動で chsh -s \$(brew --prefix)/bin/zsh を実行してください"
fi
unset _brew_zsh

log_success "zsh・Sheldon設定のセットアップが完了しました"
log_info "設定を反映するには新しいターミナルを開くか、'source ~/.zshrc' を実行してください"
log_info "次回のzsh起動時からSheldonプラグインが有効になります"
