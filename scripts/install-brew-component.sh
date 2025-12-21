#!/usr/bin/env bash

# Homebrewパッケージインストールスクリプト
# 共通ライブラリを使用してエラーハンドリングと進捗表示を改善

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "Homebrewコンポーネントのインストールを開始します"

# アーキテクチャ情報の読み込み
if [[ -f "/tmp/dotfiles_arch_info.sh" ]]; then
	# shellcheck source=/dev/null
	source "/tmp/dotfiles_arch_info.sh"
	log_info "アーキテクチャ情報を読み込みました: $ARCH"
fi

# Homebrewの初期化
init_homebrew

# Homebrewの更新とアップグレード
log_step "Homebrewを更新・アップグレード中..."
if brew update && brew upgrade; then
	log_success "Homebrewの更新・アップグレードが完了しました"
else
	log_warning "Homebrewの更新・アップグレードに失敗しましたが、継続します"
fi

# パッケージ定義
declare -a core_tools=("git" "vim" "neovim" "tmux" "jq" "wget" "curl" "fzf" "im-select")
declare -a file_utils=("ghq" "tree" "coreutils" "lsd" "ripgrep")
declare -a terminal_tools=("starship" "reattach-to-user-namespace" "gawk")
declare -a vcs_tools=("tig" "jesseduffield/lazygit/lazygit" "gh")
declare -a package_managers=("mas" "gpg" "sheldon" "mise")

# コアツールのインストール
log_step "コア開発ツールをインストール中..."
total=${#core_tools[@]}
for i in "${!core_tools[@]}"; do
	package="${core_tools[$i]}"
	show_progress $((i + 1)) "$total" "$package"

	if is_brew_package_installed "$package"; then
		log_info "$package は既にインストールされています"
	else
		if brew install "$package"; then
			log_success "$package のインストールが完了しました"
		else
			log_warning "$package のインストールに失敗しました（スキップ）"
		fi
	fi
done

# ファイル・テキストユーティリティ
log_step "ファイル・テキストユーティリティをインストール中..."
total=${#file_utils[@]}
for i in "${!file_utils[@]}"; do
	package="${file_utils[$i]}"
	show_progress $((i + 1)) "$total" "$package"

	if is_brew_package_installed "$package"; then
		log_info "$package は既にインストールされています"
	else
		if brew install "$package"; then
			log_success "$package のインストールが完了しました"
		else
			log_warning "$package のインストールに失敗しました（スキップ）"
		fi
	fi
done

# ターミナルツール
log_step "ターミナルツールをインストール中..."
total=${#terminal_tools[@]}
for i in "${!terminal_tools[@]}"; do
	package="${terminal_tools[$i]}"
	show_progress $((i + 1)) "$total" "$package"

	if is_brew_package_installed "$package"; then
		log_info "$package は既にインストールされています"
	else
		if brew install "$package"; then
			log_success "$package のインストールが完了しました"
		else
			log_warning "$package のインストールに失敗しました（スキップ）"
		fi
	fi
done

# バージョン管理ツール
log_step "バージョン管理ツールをインストール中..."
total=${#vcs_tools[@]}
for i in "${!vcs_tools[@]}"; do
	package="${vcs_tools[$i]}"
	show_progress $((i + 1)) "$total" "$package"

	if is_brew_package_installed "$package"; then
		log_info "$package は既にインストールされています"
	else
		if brew install "$package"; then
			log_success "$package のインストールが完了しました"
		else
			log_warning "$package のインストールに失敗しました（スキップ）"
		fi
	fi
done

# パッケージマネージャー
log_step "パッケージマネージャーをインストール中..."
total=${#package_managers[@]}
for i in "${!package_managers[@]}"; do
	package="${package_managers[$i]}"
	show_progress $((i + 1)) "$total" "$package"

	if is_brew_package_installed "$package"; then
		log_info "$package は既にインストールされています"
	else
		if brew install "$package"; then
			log_success "$package のインストールが完了しました"
		else
			log_warning "$package のインストールに失敗しました（スキップ）"
		fi
	fi
done

# GUI Applications
log_step "GUIアプリケーションをインストール中..."

# Browsers
log_info "ブラウザをインストール中..."
brew install --cask arc firefox

# Development tools
log_info "開発ツールをインストール中..."
brew install --cask ghostty cursor dbeaver-community docker wireshark

# Communication
log_info "コミュニケーションアプリをインストール中..."
brew install --cask slack discord zoom microsoft-teams

# Productivity
log_info "生産性向上アプリをインストール中..."
brew install --cask notion figma bitwarden clipy appcleaner libreoffice obsidian raycast

# Media and utilities
log_info "メディア・ユーティリティアプリをインストール中..."
brew install --cask spotify gyazo kindle amazon-music yt-music steam curseforge

# System utilities
log_info "システムユーティリティをインストール中..."
brew install --cask karabiner-elements logi-options-plus hammerspoon

# Optional development tools
log_info "追加開発ツールをインストール中..."
brew install --cask postman jasper

# App Store apps (requires App Store login)
log_step "App Storeアプリケーションをインストール中..."
if mas account &>/dev/null; then
	log_info "LINEアプリをインストール中..."
	if mas install 539883307; then
		log_success "LINEアプリのインストールが完了しました"
	else
		log_warning "LINEアプリのインストールに失敗しました（App Store認証が必要）"
	fi
else
	log_warning "App Storeにサインインしていないため、App Storeアプリをスキップします"
	log_info "手動インストール: mas install 539883307 (LINE)"
fi

# Font
log_step "フォントをインストール中..."
brew tap homebrew/cask-fonts
if brew install --cask font-hack-nerd-font; then
	log_success "Hack Nerd Fontのインストールが完了しました"
else
	log_warning "Hack Nerd Fontのインストールに失敗しました"
fi

log_success "すべてのHomebrewコンポーネントのインストールが完了しました"
