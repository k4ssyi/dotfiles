#!/usr/bin/env bash

# Claude Code設定セットアップスクリプト
# 共通ライブラリを使用してエラーハンドリングと日本語対応を強化

# 共通ライブラリの読み込み
source "$(dirname "$0")/lib/common.sh"

# コマンドライン引数のパース
parse_args() {
	while [[ $# -gt 0 ]]; do
		case "$1" in
		--dry-run)
			DRYRUN_MODE="true"
			log_info "ドライランモードで実行します"
			;;
		-h | --help)
			echo "使用方法: $0 [--dry-run]"
			echo "  --dry-run  実際の変更を行わず、実行内容を表示します"
			exit 0
			;;
		*)
			log_error "不明なオプション: $1"
			exit 1
			;;
		esac
		shift
	done
}

parse_args "$@"

# クリーンアップ用トラップの設定
setup_cleanup_trap

log_info "Claude Code設定のセットアップを開始します"

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# Claude設定ファイルのソースパス
claude_source_dir="$(pwd)/claude"
claude_md_source="${claude_source_dir}/CLAUDE.md"
settings_source="${claude_source_dir}/settings.json"
scripts_source="${claude_source_dir}/scripts"
agents_source="${claude_source_dir}/agents"
skills_source="${claude_source_dir}/skills"

# ターゲットディレクトリ
claude_target_dir="${HOME}/.claude"

# ソースファイルの存在確認
if [[ ! -d "$claude_source_dir" ]]; then
	handle_error "Claude設定ディレクトリが見つかりません: $claude_source_dir"
fi

# 既存設定のバックアップ
log_step "既存Claude設定のバックアップを作成中..."
create_backup "${claude_target_dir}/CLAUDE.md"
create_backup "${claude_target_dir}/settings.json"
create_backup "${claude_target_dir}/scripts"
create_backup "${claude_target_dir}/agents"
create_backup "${claude_target_dir}/skills"

# ターゲットディレクトリの作成
if [[ "$DRYRUN_MODE" == "true" ]]; then
	log_dryrun "ディレクトリ作成: $claude_target_dir"
else
	mkdir -p "$claude_target_dir"
	log_info "ディレクトリを作成しました: $claude_target_dir"
fi

# CLAUDE.mdのセットアップ
if [[ -f "$claude_md_source" ]]; then
	log_step "CLAUDE.mdのセットアップ中..."
	create_symlink "$claude_md_source" "${claude_target_dir}/CLAUDE.md" true
else
	log_warning "CLAUDE.mdファイルが見つかりません: $claude_md_source"
fi

# settings.jsonのセットアップ
if [[ -f "$settings_source" ]]; then
	log_step "settings.jsonのセットアップ中..."
	create_symlink "$settings_source" "${claude_target_dir}/settings.json" true
else
	log_warning "settings.jsonファイルが見つかりません: $settings_source"
fi

# scriptsディレクトリのセットアップ
if [[ -d "$scripts_source" ]]; then
	log_step "scriptsディレクトリのセットアップ中..."
	create_symlink "$scripts_source" "${claude_target_dir}/scripts" true
else
	log_warning "scriptsディレクトリが見つかりません: $scripts_source"
fi

# agentsディレクトリのセットアップ
if [[ -d "$agents_source" ]]; then
	log_step "agentsディレクトリのセットアップ中..."
	create_symlink "$agents_source" "${claude_target_dir}/agents" true
else
	log_warning "agentsディレクトリが見つかりません: $agents_source"
fi

# skillsディレクトリのセットアップ
if [[ -d "$skills_source" ]]; then
	log_step "skillsディレクトリのセットアップ中..."
	create_symlink "$skills_source" "${claude_target_dir}/skills" true
else
	log_warning "skillsディレクトリが見つかりません: $skills_source"
fi

# 設定確認
log_info "セットアップ結果の確認:"
if [[ "$DRYRUN_MODE" != "true" ]]; then
	for item in CLAUDE.md settings.json scripts agents skills; do
		target="${claude_target_dir}/${item}"
		if [[ -L "$target" ]]; then
			source_path=$(readlink "$target")
			log_success "  $item -> $source_path"
		elif [[ -e "$target" ]]; then
			log_warning "  $item (リンクではありません)"
		else
			log_warning "  $item (存在しません)"
		fi
	done
fi

log_success "Claude Code設定のセットアップが完了しました"
log_info "Claude Codeを再起動して設定を反映してください"
