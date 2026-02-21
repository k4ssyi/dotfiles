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

# SSH署名鍵を対話的に選択する共通関数
# stdout に選択された鍵パスを出力。鍵がなければ何も出力しない。
select_signing_key() {
	local ssh_pub_keys=(~/.ssh/*.pub)

	# グロブ未展開の場合（nullglob未設定で鍵がない場合）
	if [[ ${#ssh_pub_keys[@]} -eq 0 ]] || [[ ! -f "${ssh_pub_keys[0]}" ]]; then
		return
	fi

	if [[ ${#ssh_pub_keys[@]} -eq 1 ]]; then
		log_info "SSH署名鍵を検出しました: ${ssh_pub_keys[0]}"
		echo "${ssh_pub_keys[0]}"
		return
	fi

	log_info "複数のSSH公開鍵が見つかりました:"
	for i in "${!ssh_pub_keys[@]}"; do
		log_info "  $((i + 1)). ${ssh_pub_keys[$i]}"
	done
	printf "  署名に使用する鍵の番号を選択 [1]: "
	read -r key_choice
	if [[ ! "${key_choice:-1}" =~ ^[0-9]+$ ]]; then
		key_choice=1
		log_warning "無効な入力です。デフォルト(1)を使用します"
	fi
	local key_index=$(( ${key_choice:-1} - 1 ))
	if [[ $key_index -ge 0 && $key_index -lt ${#ssh_pub_keys[@]} ]]; then
		echo "${ssh_pub_keys[$key_index]}"
	else
		log_warning "無効な選択です。デフォルトを使用: ${ssh_pub_keys[0]}"
		echo "${ssh_pub_keys[0]}"
	fi
}

# Git設定ファイルの存在確認
git_config_source="$(pwd)/git/.gitconfig"
gitignore_source="$(pwd)/git/gitignore_global"

# 既存設定のバックアップ
log_step "既存Git設定のバックアップを作成中..."
create_backup "${HOME}/.gitconfig"
create_backup "${HOME}/.config/git"

# ~/.gitconfig.local の存在チェックと対話的生成
gitconfig_local="${HOME}/.gitconfig.local"
if [[ ! -f "$gitconfig_local" ]]; then
	log_warning "~/.gitconfig.local が見つかりません（Gitユーザー情報の設定に必要）"

	if [[ "$DRYRUN_MODE" == "true" ]]; then
		log_dryrun "~/.gitconfig.local の対話的生成をスキップ"
	else
		# 既存の git config から初期値を取得（あれば）
		default_name=$(git config user.name 2>/dev/null || echo "")
		default_email=$(git config user.email 2>/dev/null || echo "")

		log_info "Gitユーザー情報を入力してください"

		printf "  ユーザー名"
		[[ -n "$default_name" ]] && printf " [%s]" "$default_name"
		printf ": "
		read -r input_name
		git_name="${input_name:-$default_name}"

		printf "  メールアドレス"
		[[ -n "$default_email" ]] && printf " [%s]" "$default_email"
		printf ": "
		read -r input_email
		git_email="${input_email:-$default_email}"

		# SSH署名鍵の自動検出
		signing_key=""
		signing_key=$(select_signing_key) || true

		if [[ -n "$git_name" && -n "$git_email" ]]; then
			: > "$gitconfig_local"
			git config --file "$gitconfig_local" user.name "$git_name"
			git config --file "$gitconfig_local" user.email "$git_email"
			if [[ -n "$signing_key" ]]; then
				git config --file "$gitconfig_local" user.signingkey "$signing_key"
				# allowed_signers ファイルの生成（署名検証用）
				allowed_signers="${HOME}/.ssh/allowed_signers"
				if [[ ! -f "$allowed_signers" ]] || ! grep -qF "$git_email" "$allowed_signers"; then
					pub_key_content=$(cat "$signing_key")
					echo "$git_email $pub_key_content" >>"$allowed_signers"
					chmod 600 "$allowed_signers"
					log_success "allowed_signers を更新しました: $allowed_signers"
				fi
			fi
			log_success "~/.gitconfig.local を作成しました（name=$git_name, email=$git_email）"
			[[ -n "$signing_key" ]] && log_success "署名鍵を設定しました: $signing_key"
		else
			log_warning "ユーザー名またはメールアドレスが空のため、~/.gitconfig.local の作成をスキップしました"
			log_info "後から手動で作成してください:"
			log_info "  git config --global user.name 'Your Name'"
			log_info "  git config --global user.email 'your@email.com'"
		fi
	fi
else
	log_info "~/.gitconfig.local は既に存在します"
	# signingkey が未設定の場合は追記
	if ! grep -q "signingkey" "$gitconfig_local"; then
		signing_key=$(select_signing_key) || true
		if [[ -n "$signing_key" ]]; then
			git config --file "$gitconfig_local" user.signingkey "$signing_key"
			log_success "署名鍵を ~/.gitconfig.local に追記しました: $signing_key"
			# allowed_signers ファイルの更新（署名検証用）
			git_email_local=$(git config --file "$gitconfig_local" user.email 2>/dev/null || echo "")
			if [[ -n "$git_email_local" ]]; then
				allowed_signers="${HOME}/.ssh/allowed_signers"
				if [[ ! -f "$allowed_signers" ]] || ! grep -qF "$git_email_local" "$allowed_signers"; then
					pub_key_content=$(cat "$signing_key")
					echo "$git_email_local $pub_key_content" >>"$allowed_signers"
					chmod 600 "$allowed_signers"
					log_success "allowed_signers を更新しました: $allowed_signers"
				fi
			fi
		else
			log_warning "SSH公開鍵が見つかりません。署名鍵は手動で設定してください"
		fi
	fi
fi

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
		log_info "~/.gitconfig.local を編集してください:"
		log_info "  [user]"
		log_info "      name = Your Name"
		log_info "      email = your@email.com"
	fi
else
	log_warning "Gitがインストールされていません。先にHomebrewパッケージをインストールしてください"
fi

# Pre-commit フックの設定（dotfiles リポジトリ専用。他リポジトリへの適用は git template 等で別途対応）
hook_source="$(pwd)/git/hooks/pre-commit"
hook_target="$(pwd)/.git/hooks/pre-commit"

if [[ -f "$hook_source" ]]; then
	log_step "Pre-commit フックのセットアップ中..."
	create_symlink "$hook_source" "$hook_target" true
	# 実行権限の確認
	if [[ "$DRYRUN_MODE" != "true" ]] && [[ ! -x "$hook_source" ]]; then
		chmod +x "$hook_source"
	fi
else
	log_warning "Pre-commit フックが見つかりません: $hook_source"
fi

log_success "Git設定のセットアップが完了しました"
