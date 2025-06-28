#!/usr/bin/env bash

# Neovim設定セットアップスクリプト
# 共通ライブラリを使用してエラーハンドリングと日本語対応を強化

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "Neovim設定のセットアップを開始します"

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# 設定ファイルの存在確認
nvim_source="$(pwd)/nvim"
vscode_nvim_source="$(pwd)/vscode-nvim"

if [[ ! -d "$nvim_source" ]]; then
	handle_error "Neovim設定ディレクトリが見つかりません: $nvim_source"
fi

if [[ ! -d "$vscode_nvim_source" ]]; then
	handle_error "VSCode Neovim設定ディレクトリが見つかりません: $vscode_nvim_source"
fi

# 既存設定のバックアップ
log_step "既存設定のバックアップを作成中..."
create_backup "${HOME}/.config/nvim"
create_backup "${HOME}/.config/vscode-nvim"

# Neovim設定のセットアップ
log_step "Neovim設定のセットアップ中..."
mkdir -p "${HOME}/.config"
create_symlink "$nvim_source" "${HOME}/.config/nvim" true

# VSCode Neovim設定のセットアップ
log_step "VSCode Neovim設定のセットアップ中..."
create_symlink "$vscode_nvim_source" "${HOME}/.config/vscode-nvim" true

# Cursor エディターの設定（Cursorがインストールされている場合）
cursor_support_dir="${HOME}/Library/Application Support/Cursor"
if [[ -d "$cursor_support_dir" ]]; then
	log_step "Cursorエディターの設定をセットアップ中..."

	cursor_user_dir="$cursor_support_dir/User"
	mkdir -p "$cursor_user_dir"

	# 設定ファイルの存在確認
	settings_source="${HOME}/.config/vscode-nvim/settings.json"
	keybindings_source="${HOME}/.config/vscode-nvim/vscode-keybindings.json"

	if [[ -f "$settings_source" ]]; then
		create_backup "$cursor_user_dir/settings.json"
		create_symlink "$settings_source" "$cursor_user_dir/settings.json" true
	else
		log_warning "VSCode Neovim settings.jsonが見つかりません: $settings_source"
	fi

	if [[ -f "$keybindings_source" ]]; then
		create_backup "$cursor_user_dir/keybindings.json"
		create_symlink "$keybindings_source" "$cursor_user_dir/keybindings.json" true
	else
		log_warning "VSCode Neovim keybindings.jsonが見つかりません: $keybindings_source"
	fi

	log_success "Cursorエディターの設定が完了しました"
else
	log_info "Cursorエディターがインストールされていないため、スキップします"
fi

# VSCode の設定（VSCodeがインストールされている場合）
vscode_support_dir="${HOME}/Library/Application Support/Code"
if [[ -d "$vscode_support_dir" ]]; then
	log_step "VSCodeの設定をセットアップ中..."

	vscode_user_dir="$vscode_support_dir/User"
	mkdir -p "$vscode_user_dir"

	# 設定ファイルの存在確認とリンク作成
	settings_source="${HOME}/.config/vscode-nvim/settings.json"
	keybindings_source="${HOME}/.config/vscode-nvim/vscode-keybindings.json"

	if [[ -f "$settings_source" ]]; then
		create_backup "$vscode_user_dir/settings.json"
		create_symlink "$settings_source" "$vscode_user_dir/settings.json" true
	fi

	if [[ -f "$keybindings_source" ]]; then
		create_backup "$vscode_user_dir/keybindings.json"
		create_symlink "$keybindings_source" "$vscode_user_dir/keybindings.json" true
	fi

	log_success "VSCodeの設定が完了しました"
else
	log_info "VSCodeがインストールされていないため、スキップします"
fi

# Neovimの実行確認
if command_exists nvim; then
	nvim_version=$(nvim --version | head -1 | cut -d' ' -f2)
	log_success "Neovimが利用可能です: $nvim_version"
else
	log_warning "Neovimがインストールされていません。先にHomebrewパッケージをインストールしてください"
fi

log_success "Neovim設定のセットアップが完了しました"
log_info "Neovimを起動してプラグインの初期化を行ってください"
