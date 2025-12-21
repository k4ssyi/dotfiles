#!/usr/bin/env bash

# Dotfiles セットアップスクリプト
# 他のマシンでdotfiles設定を同期するためのワンコマンドインストーラー
# 共通ライブラリを使用してエラーハンドリングと日本語対応を強化

# Usage: ./install.sh [--dry-run|--help]

# ヘルプ表示
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
	cat <<EOF
Dotfiles セットアップスクリプト

使用方法:
  ./install.sh                実際にインストールを実行
  ./install.sh --dry-run      ドライランモード（ファイル変更なし）
  ./install.sh --help         このヘルプを表示

ドライランモード:
  --dry-run または -d オプションを使用すると、実際のファイル変更を行わずに
  処理内容を確認できます。初回実行前のテストに推奨します。

注意事項:
  - 一部の処理でsudo権限が必要です
  - Homebrewの初回インストールには時間がかかる場合があります
  - Karabiner Elements、Hammerspoonは手動で権限設定が必要です
EOF
	exit 0
fi

# ドライランモードの設定
export DRYRUN_MODE=false
if [[ "$1" == "--dry-run" || "$1" == "-d" ]]; then
	export DRYRUN_MODE=true
	shift
fi

# 共通ライブラリの読み込み
source "$(dirname "$0")/scripts/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

if [[ "$DRYRUN_MODE" == "true" ]]; then
	log_dryrun "ドライランモードで実行中 - 実際のファイル変更は行いません"
fi

log_info "dotfilesインストールを開始します"
echo "================================="

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# 事前チェックの実行
log_step "システムの事前チェックを実行中..."
if ./scripts/check-prerequisites.sh; then
	log_success "事前チェックが正常に完了しました"
else
	handle_error "事前チェックに失敗しました"
fi

echo ""
echo "================================="

# 各セットアップスクリプトの実行（エラー時も継続）
scripts_to_run=(
	"scripts/setup-brew.sh:Homebrewのセットアップ"
	"scripts/install-brew-component.sh:Homebrewパッケージのインストール"
	"scripts/install-alacritty.sh:Alacritty設定"
	"scripts/install-ghostty.sh:Ghostty設定"
	"scripts/install-starship.sh:Starship設定"
	"scripts/uninstall-python27.sh:Python 2.7のクリーンアップ"
	"scripts/install-mise.sh:mise設定"
	"scripts/install-zsh-conf.sh:zsh・Sheldon設定"
	"scripts/install-git-conf.sh:Git設定"
	"scripts/install-vim-conf.sh:Neovim設定"
	"scripts/install-tmux-conf.sh:tmux設定"
	"scripts/install-hammerspoon.sh:Hammerspoon設定"
	"scripts/install-karabiner.sh:Karabiner設定"
)

failed_scripts=()
total_scripts=${#scripts_to_run[@]}

for i in "${!scripts_to_run[@]}"; do
	IFS=':' read -r script_path description <<<"${scripts_to_run[$i]}"

	show_progress $((i + 1)) "$total_scripts" "$description"

	if [[ -f "$script_path" ]]; then
		log_step "$description を実行中..."
		if [[ "$DRYRUN_MODE" == "true" ]]; then
			log_dryrun "スクリプト実行: $script_path"
			log_success "$description が完了しました（ドライラン）"
		else
			if measure_time "./$script_path"; then
				log_success "$description が完了しました"
			else
				log_warning "$description に失敗しました（継続します）"
				failed_scripts+=("$description")
			fi
		fi
	else
		log_warning "スクリプトが見つかりません: $script_path"
		failed_scripts+=("$description (スクリプト未発見)")
	fi

	echo ""
done

echo "================================="

# 結果の表示
if [[ ${#failed_scripts[@]} -eq 0 ]]; then
	log_success "すべてのdotfiles設定が正常に完了しました！"
else
	log_warning "以下の設定で問題が発生しました:"
	for failed in "${failed_scripts[@]}"; do
		log_warning "  - $failed"
	done
	echo ""
	log_info "失敗した設定は手動で確認・実行してください"
fi

echo ""
log_info "次の手順:"
log_info "  1. 新しいターミナルを開くか 'source ~/.zshrc' を実行"
log_info "  2. 必要に応じてアプリケーションの権限設定を行う"
log_info "  3. Neovimを起動してプラグインの初期化を行う"

log_success "dotfilesセットアップが完了しました！"
