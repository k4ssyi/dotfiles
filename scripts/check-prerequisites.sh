#!/usr/bin/env bash

# システム前提条件チェックスクリプト
# 共通ライブラリを使用してログ出力と規約準拠を保証

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_step "システム前提条件のチェックを開始します"
echo "================================="

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# 1. Check macOS only
if [[ "$(uname)" != "Darwin" ]]; then
	handle_error "このスクリプトはmacOS専用です"
fi

# 2. Check macOS version (require macOS 10.15+)
MACOS_VERSION=$(sw_vers -productVersion)
MAJOR_VERSION=$(echo "$MACOS_VERSION" | cut -d '.' -f 1)
MINOR_VERSION=$(echo "$MACOS_VERSION" | cut -d '.' -f 2)
# macOS 11+ では MINOR_VERSION が空になる場合があるためデフォルト値を設定
MINOR_VERSION="${MINOR_VERSION:-0}"

if [[ "$MAJOR_VERSION" -lt 10 ]] || [[ "$MAJOR_VERSION" -eq 10 && "$MINOR_VERSION" -lt 15 ]]; then
	handle_error "macOS 10.15 (Catalina) 以降が必要です。現在のバージョン: $MACOS_VERSION"
fi

log_success "macOS $MACOS_VERSION を検出しました"

# 3. Check and install Xcode Command Line Tools
log_step "Xcode Command Line Tools を確認中..."
if ! xcode-select -p &>/dev/null; then
	log_warning "Xcode Command Line Tools が見つかりません。インストールを開始します..."
	xcode-select --install
	log_warning "Xcode Command Line Tools のインストールが完了したら、このスクリプトを再実行してください"
	log_info "インストール状態の確認: xcode-select -p"
	exit 1
else
	log_success "Xcode Command Line Tools を検出: $(xcode-select -p)"
fi

# 4. Detect architecture for Homebrew paths
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
	export HOMEBREW_PREFIX="/opt/homebrew"
	log_success "Apple Silicon (ARM64) を検出 - Homebrew path: $HOMEBREW_PREFIX"
elif [[ "$ARCH" == "x86_64" ]]; then
	export HOMEBREW_PREFIX="/usr/local"
	log_success "Intel (x86_64) を検出 - Homebrew path: $HOMEBREW_PREFIX"
else
	handle_error "サポートされていないアーキテクチャ: $ARCH"
fi

# Save architecture info for other scripts (環境変数方式)
export DOTFILES_HOMEBREW_PREFIX="$HOMEBREW_PREFIX"
export DOTFILES_ARCH="$ARCH"

# 5. Check for admin privileges
log_step "管理者権限を確認中..."
if [[ "$DRYRUN_MODE" == "true" ]]; then
	log_dryrun "sudoチェックをスキップします"
elif ! sudo -n true 2>/dev/null; then
	log_warning "このスクリプトにはsudo権限が必要です"
	log_info "インストール中にパスワードを求められる場合があります"
	sudo -v || {
		handle_error "sudo権限を取得できません"
	}
else
	log_success "管理者権限を確認しました"
fi

# 6. Check internet connectivity
log_step "インターネット接続を確認中..."
if ! curl -s --head --connect-timeout 5 https://github.com >/dev/null; then
	handle_error "インストールにはインターネット接続が必要です。ネットワーク接続を確認してください"
fi
log_success "インターネット接続を確認しました"

# 7. Check if mas (Mac App Store CLI) is available
log_step "Mac App Store CLI を確認中..."
if command_exists mas; then
	log_success "mas がインストール済みです"
	# NOTE: mas account は macOS 12+ で動作しないため、サインイン確認はスキップ。
	# App Storeアプリのインストールは直接 mas install を試行する。
	log_info "App Storeアプリは直接インストールを試行します（サインインが必要な場合があります）"
else
	log_info "mas (Mac App Store CLI) 未インストール - 後でインストールされます"
fi

# 8. Check available disk space (require at least 2GB)
log_step "ディスク空き容量を確認中..."
# POSIX互換: df -k はGNU/BSD両方で動作する
AVAILABLE_KB=$(df -k . | tail -1 | awk '{print $4}')
AVAILABLE_SPACE=$((AVAILABLE_KB / 1024 / 1024))
if [[ "$AVAILABLE_SPACE" -lt 2 ]]; then
	handle_error "ディスク容量不足。2GB以上必要ですが、${AVAILABLE_SPACE}GB しかありません"
fi
log_success "ディスク空き容量: ${AVAILABLE_SPACE}GB"

# 9. Check if zsh is available
log_step "シェルの状態を確認中..."
if ! command_exists zsh; then
	handle_error "zshが見つかりません。macOS 10.15以降ではデフォルトで利用可能なはずです"
fi

# Check if zsh is already the default shell
if [[ "$SHELL" != "$(command -v zsh)" ]]; then
	log_warning "現在のシェルは $SHELL ですが、zsh を推奨します"
	log_info "zshをデフォルトシェルに設定: chsh -s $(command -v zsh)"
fi
log_success "zsh を検出: $(command -v zsh)"

# 10. Warning about permissions that require manual intervention
echo ""
log_warning "重要な注意事項:"
log_info "  - Karabiner Elements にはアクセシビリティ権限が必要です"
log_info "  - Hammerspoon にはアクセシビリティ権限が必要です"
log_info "  - 一部のインストールでパスワード入力が必要です"
log_info "  - 初回のHomebrewインストールには10分以上かかる場合があります"
echo ""

echo "================================="
log_success "全ての前提条件チェックが完了しました"
log_info "実行準備完了: ./install.sh"
echo ""
