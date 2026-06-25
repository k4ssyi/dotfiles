#!/usr/bin/env bash

# go install で導入する Go 製 CLI ツールのセットアップスクリプト
# go 本体は mise（install-mise.sh の golang@latest）で管理される前提

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "Go製CLIツールのセットアップを開始します"

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# go バイナリの解決
# 優先順位: PATH上のgo > mise管理の既存インストール
# NOTE: mise のパス解決サブコマンド (which) はカレントディレクトリでactiveなgoが必要なため使わない。
#       `mise exec golang@latest` は最新版を新規DLしてしまうため使わない。
#       `mise where go` は既にインストール済みのgoのパスのみを返すので追加DLが発生しない。
resolve_go() {
	if command_exists go; then
		command -v go
		return 0
	fi

	local mise_go_dir
	if command_exists mise && mise_go_dir=$(mise where go 2>/dev/null) && [[ -x "${mise_go_dir}/bin/go" ]]; then
		echo "${mise_go_dir}/bin/go"
		return 0
	fi

	return 1
}

GO_BIN=$(resolve_go) || {
	log_warning "goが見つかりません。先にinstall-mise.sh（golang@latest）を実行してください"
	exit 1
}
log_info "使用するgo: $GO_BIN ($("$GO_BIN" version 2>/dev/null))"

# go install の出力先（GOPATH/bin）。zsh/.zshrc でPATHに追加済み（~/go/bin）
GO_BIN_DIR="$("$GO_BIN" env GOPATH)/bin"

# インストールするツール（パッケージパス）
# NOTE: @latest はインストール時点の最新タグに解決される
go_tools=(
	"github.com/kevindutra/crit/cmd/crit@latest"
)

log_step "Go製ツールをインストール中..."

for tool in "${go_tools[@]}"; do
	# パッケージパスから実行ファイル名を推測（cmd/<name>@... または .../<name>@...）
	tool_name=$(echo "$tool" | sed -E 's#@.*$##; s#.*/##')

	log_info "$tool をインストール中..."

	if [[ "$DRYRUN_MODE" == "true" ]]; then
		log_dryrun "go install $tool"
		continue
	fi

	if "$GO_BIN" install "$tool"; then
		log_success "$tool_name をインストールしました ($GO_BIN_DIR/$tool_name)"
	else
		log_warning "$tool のインストールに失敗しました"
	fi
done

log_success "Go製CLIツールのセットアップが完了しました"
log_info "$GO_BIN_DIR がPATHに含まれている必要があります（zsh/.zshrcで設定済み）"
