#!/usr/bin/env bash

# tmux設定セットアップスクリプト
# 共通ライブラリを使用してエラーハンドリングと日本語対応を強化

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "tmux設定のセットアップを開始します"

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# tmux設定ファイルの存在確認
tmux_config_source="$(pwd)/tmux/.tmux.conf"

if [[ ! -f "$tmux_config_source" ]]; then
	handle_error "tmux設定ファイルが見つかりません: $tmux_config_source"
fi

# 既存設定のバックアップ
log_step "既存tmux設定のバックアップを作成中..."
create_backup "${HOME}/.tmux.conf"
create_backup "${HOME}/.tmux"

# tmux設定のセットアップ
log_step "tmux設定のセットアップ中..."
create_symlink "$tmux_config_source" "${HOME}/.tmux.conf" true

# TPM (Tmux Plugin Manager) のセットアップ
log_step "TPM (Tmux Plugin Manager) のセットアップ中..."
tpm_dir="${HOME}/.tmux/plugins/tpm"

if [[ ! -d "$tpm_dir" ]]; then
	if git clone https://github.com/tmux-plugins/tpm "$tpm_dir"; then
		log_success "TPMのインストールが完了しました"
	else
		log_warning "TPMのインストールに失敗しました"
	fi
else
	log_info "TPMは既にインストールされています"
fi

# tmuxの実行確認
if command_exists tmux; then
	tmux_version=$(tmux -V | cut -d' ' -f2)
	log_success "tmuxが利用可能です: $tmux_version"

	# tmuxが実行中の場合のみ設定を再読み込み
	if tmux list-sessions &>/dev/null; then
		log_step "tmux設定を再読み込み中..."
		if tmux source "${HOME}/.tmux.conf"; then
			log_success "tmux設定の再読み込みが完了しました"
		else
			log_warning "tmux設定の再読み込みに失敗しました"
		fi
	else
		log_info "tmuxセッションが実行されていません。次回起動時に設定が適用されます"
	fi
else
	log_warning "tmuxがインストールされていません。先にHomebrewパッケージをインストールしてください"
fi

log_success "tmux設定のセットアップが完了しました"
log_info "tmuxを起動後、prefix + I でプラグインをインストールしてください"
