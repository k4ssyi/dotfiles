#!/usr/bin/env bash

# Homebrewセットアップスクリプト
# 共通ライブラリを使用してエラーハンドリングと日本語対応を強化

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "Homebrewのインストール状況を確認中..."

# Homebrewが既にインストールされているかチェック
if command_exists brew; then
	log_success "Homebrewは既にインストールされています"
	log_info "バージョン: $(brew --version | head -1)"

	# Homebrewパスの初期化
	init_homebrew
else
	log_step "Homebrewをインストール中..."

	# セキュリティ：公式インストールスクリプトの実行
	if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
		handle_error "Homebrewのインストールに失敗しました"
	fi

	# アーキテクチャに応じたPATH設定
	homebrew_prefix=$(get_homebrew_prefix)

	if [[ -f "$homebrew_prefix/bin/brew" ]]; then
		# .zprofileにPATH設定を追加（重複チェック付き）
		brew_shellenv="eval \"\$($homebrew_prefix/bin/brew shellenv)\""

		if [[ -f ~/.zprofile ]] && grep -q "brew shellenv" ~/.zprofile; then
			log_info "brew shellenvは既に.zprofileに設定されています"
		else
			echo "$brew_shellenv" >>~/.zprofile
			log_success ".zprofileにbrew shellenvを追加しました"
		fi

		# 現在のセッションで有効化
		eval "$("$homebrew_prefix"/bin/brew shellenv)"
		log_success "Homebrewのインストールが完了しました: $homebrew_prefix"
	else
		handle_error "Homebrewのインストールは完了しましたが、実行ファイルが見つかりません"
	fi
fi

# アーキテクチャ情報の保存
save_arch_info

# Homebrewの更新
log_step "Homebrewを更新中..."
if brew update; then
	log_success "Homebrewの更新が完了しました"
else
	log_warning "Homebrewの更新に失敗しましたが、継続します"
fi

log_success "Homebrewのセットアップが完了しました"
