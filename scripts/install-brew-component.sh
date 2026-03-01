#!/usr/bin/env bash

# Homebrewパッケージインストールスクリプト
# 共通ライブラリを使用してエラーハンドリングと進捗表示を改善

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "Homebrewコンポーネントのインストールを開始します"

# アーキテクチャ情報の読み込み（安全な一時ファイル or 環境変数から）
if [[ -n "${DOTFILES_ARCH_INFO_FILE:-}" && -f "$DOTFILES_ARCH_INFO_FILE" ]]; then
	# shellcheck source=/dev/null
	source "$DOTFILES_ARCH_INFO_FILE"
	log_info "アーキテクチャ情報を読み込みました: ${ARCH:-unknown}"
elif [[ -n "${DOTFILES_HOMEBREW_PREFIX:-}" ]]; then
	export HOMEBREW_PREFIX="$DOTFILES_HOMEBREW_PREFIX"
	export ARCH="${DOTFILES_ARCH:-$(uname -m)}"
	log_info "環境変数からアーキテクチャ情報を読み込みました: $ARCH"
fi

# Homebrewの初期化
init_homebrew

# Homebrewの更新とアップグレード
if [[ "$DRYRUN_MODE" == "true" ]]; then
	log_dryrun "brew update && brew upgrade"
else
	log_step "Homebrewを更新・アップグレード中..."
	if brew update && brew upgrade; then
		log_success "Homebrewの更新・アップグレードが完了しました"
	else
		log_warning "Homebrewの更新・アップグレードに失敗しましたが、継続します"
	fi
fi

# ----------------------------
# formula/cask 共通インストール関数
# ----------------------------

# formulaパッケージをインストールする共通関数
# 使い方: install_formula_packages "カテゴリ名" "${array[@]}"
install_formula_packages() {
	local label="$1"
	shift
	local -a packages=("$@")

	log_step "${label}をインストール中..."
	local total=${#packages[@]}
	for i in "${!packages[@]}"; do
		local package="${packages[$i]}"
		local package_short="${package##*/}" # tap prefix を除いた実名
		show_progress $((i + 1)) "$total" "$package"

		if is_brew_package_installed "$package_short"; then
			log_info "$package は既にインストールされています"
		elif [[ "$DRYRUN_MODE" == "true" ]]; then
			log_dryrun "brew install $package"
		else
			if brew install "$package"; then
				log_success "$package のインストールが完了しました"
			else
				log_warning "$package のインストールに失敗しました（スキップ）"
			fi
		fi
	done
}

# caskパッケージをインストールする共通関数
# 使い方: install_cask_packages "カテゴリ名" "${array[@]}"
install_cask_packages() {
	local label="$1"
	shift
	local -a packages=("$@")

	log_info "${label}をインストール中..."
	for package in "${packages[@]}"; do
		if is_brew_package_installed "$package" "cask"; then
			log_info "$package は既にインストールされています"
		elif [[ "$DRYRUN_MODE" == "true" ]]; then
			log_dryrun "brew install --cask $package"
		else
			if brew install --cask "$package"; then
				log_success "$package のインストールが完了しました"
			else
				log_warning "$package のインストールに失敗しました（スキップ）"
			fi
		fi
	done
}

# ----------------------------
# パッケージ定義
# ----------------------------

if [[ "$DRYRUN_MODE" == "true" ]]; then
	log_dryrun "brew tap daipeihust/tap"
else
	brew tap daipeihust/tap
fi

declare -a core_tools=("bash" "zsh" "git" "vim" "neovim" "tmux" "make" "jq" "wget" "curl" "fzf" "im-select" "shellcheck")
declare -a file_utils=("ghq" "tree" "coreutils" "lsd" "ripgrep" "grep" "fd" "bat")
declare -a terminal_tools=("starship" "reattach-to-user-namespace" "gawk" "fastfetch" "csvlens")
declare -a vcs_tools=("tig" "jesseduffield/lazygit/lazygit" "gh" "git-delta")
declare -a ai_tools=("gemini-cli")
declare -a network_tools=("nmap")
declare -a package_managers=("mas" "gpg" "sheldon" "mise")

# ----------------------------
# CLI ツールのインストール
# ----------------------------

install_formula_packages "コア開発ツール" "${core_tools[@]}"
install_formula_packages "ファイル・テキストユーティリティ" "${file_utils[@]}"
install_formula_packages "ターミナルツール" "${terminal_tools[@]}"
install_formula_packages "バージョン管理ツール" "${vcs_tools[@]}"
install_formula_packages "AIツール" "${ai_tools[@]}"
install_formula_packages "ネットワークツール" "${network_tools[@]}"
install_formula_packages "パッケージマネージャー" "${package_managers[@]}"

# ----------------------------
# GUI アプリケーションのインストール
# ----------------------------

log_step "GUIアプリケーションをインストール中..."

declare -a cask_browsers=("arc" "firefox" "google-chrome")
declare -a cask_dev_tools=("ghostty" "cursor" "dbeaver-community" "docker-desktop" "wireshark-app")
declare -a cask_ai_tools=("claude" "claude-code" "codex")
declare -a cask_communication=("slack" "discord" "zoom" "microsoft-teams")
declare -a cask_productivity=("notion" "figma" "bitwarden" "clipy" "appcleaner" "libreoffice" "obsidian" "raycast")
declare -a cask_entertainment=("spotify")
declare -a cask_system=("karabiner-elements" "logi-options-plus" "hammerspoon" "tailscale")
declare -a cask_optional_dev=("postman")

install_cask_packages "ブラウザ" "${cask_browsers[@]}"
install_cask_packages "開発ツール" "${cask_dev_tools[@]}"
install_cask_packages "AI開発ツール" "${cask_ai_tools[@]}"
install_cask_packages "コミュニケーション" "${cask_communication[@]}"
install_cask_packages "生産性向上アプリ" "${cask_productivity[@]}"
install_cask_packages "エンターテインメント" "${cask_entertainment[@]}"
install_cask_packages "システムユーティリティ" "${cask_system[@]}"
install_cask_packages "追加開発ツール" "${cask_optional_dev[@]}"

# ----------------------------
# App Store アプリケーション
# ----------------------------

log_step "App Storeアプリケーションをインストール中..."

# bash 3.2 互換のため並列配列で名前とIDを対応させる
declare -a mas_app_names=("LINE" "RunCat")
declare -a mas_app_ids=("539883307" "1429033973")

# NOTE: mas account は macOS 12+ で動作しないため、直接インストールを試行する
for i in "${!mas_app_names[@]}"; do
	app_name="${mas_app_names[$i]}"
	app_id="${mas_app_ids[$i]}"
	if [[ "$DRYRUN_MODE" == "true" ]]; then
		log_dryrun "mas install $app_id ($app_name)"
	else
		log_info "$app_name をインストール中..."
		if mas install "$app_id"; then
			log_success "$app_name のインストールが完了しました"
		else
			log_warning "$app_name のインストールに失敗しました（App Storeへのサインインが必要な場合があります）"
		fi
	fi
done

# ----------------------------
# フォント
# ----------------------------

log_step "フォントをインストール中..."
# homebrew/cask-fonts は2024年に homebrew/cask に統合済み（tap不要）
if [[ "$DRYRUN_MODE" == "true" ]]; then
	log_dryrun "brew install --cask font-hack-nerd-font"
elif brew install --cask font-hack-nerd-font; then
	log_success "Hack Nerd Fontのインストールが完了しました"
else
	log_warning "Hack Nerd Fontのインストールに失敗しました"
fi

log_success "すべてのHomebrewコンポーネントのインストールが完了しました"
