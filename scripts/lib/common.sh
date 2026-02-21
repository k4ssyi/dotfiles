#!/usr/bin/env bash

# 共通関数ライブラリ
# dotfilesプロジェクト全体で使用される共通機能を提供

# 厳密なエラーハンドリング
set -euo pipefail

# 安全なファイルパーミッション（ユーザーのumask設定に依存しない）
umask 022

# ドライランモード設定
DRYRUN_MODE="${DRYRUN_MODE:-false}"

# カラー定義
readonly RED='\033[31m'
readonly GREEN='\033[32m'
readonly YELLOW='\033[33m'
readonly BLUE='\033[34m'
readonly PURPLE='\033[35m'
readonly CYAN='\033[36m'
readonly NC='\033[0m' # No Color

# ログ関数（日本語対応）
log_info() {
	echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
	echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
	echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
	echo -e "${RED}❌ $1${NC}" >&2
}

log_step() {
	echo -e "${PURPLE}🔄 $1${NC}"
}

log_dryrun() {
	echo -e "${CYAN}🧪 [DRYRUN] $1${NC}"
}

# エラーハンドリング関数
handle_error() {
	local error_message="$1"
	local exit_code="${2:-1}"
	log_error "エラーが発生しました: $error_message"
	exit "$exit_code"
}

# プロジェクトルートディレクトリの確認
ensure_dotfiles_root() {
	if [[ ! -f "./install.sh" ]]; then
		handle_error "dotfilesディレクトリから実行してください"
	fi
	log_info "dotfilesディレクトリを確認しました: $(pwd)"
}

# Homebrewパスの取得（アーキテクチャ対応）
get_homebrew_prefix() {
	if [[ "$(uname -m)" == "arm64" ]]; then
		echo "/opt/homebrew"
	else
		echo "/usr/local"
	fi
}

# Homebrewの初期化
init_homebrew() {
	local homebrew_prefix
	homebrew_prefix=$(get_homebrew_prefix)

	if [[ -f "$homebrew_prefix/bin/brew" ]]; then
		eval "$("$homebrew_prefix"/bin/brew shellenv)"
		log_success "Homebrewを初期化しました: $homebrew_prefix"
	else
		handle_error "Homebrewが見つかりません: $homebrew_prefix"
	fi
}

# コマンドの存在確認
command_exists() {
	command -v "$1" &>/dev/null
}

# パッケージがインストール済みかチェック
is_brew_package_installed() {
	local package_name="$1"
	local package_type="${2:-formula}" # formula or cask

	if [[ "$package_type" == "cask" ]]; then
		brew list --cask | grep -q "^${package_name}$"
	else
		brew list --formula | grep -q "^${package_name}$"
	fi
}

# シンボリックリンクの安全な作成
create_symlink() {
	local source="$1"
	local target="$2"
	local force="${3:-false}"

	# ソースファイルの存在確認
	if [[ ! -e "$source" ]]; then
		log_warning "リンク元が存在しません: $source"
		return 1
	fi

	# ドライランモード処理
	if [[ "$DRYRUN_MODE" == "true" ]]; then
		log_dryrun "ディレクトリ作成: $(dirname "$target")"
		if [[ -L "$target" ]]; then
			log_dryrun "既存リンク削除: $target"
		elif [[ -e "$target" ]]; then
			log_dryrun "既存ファイル削除: $target"
		fi
		log_dryrun "シンボリックリンク作成: $target -> $source"
		return 0
	fi

	# ターゲットディレクトリの作成
	local target_dir
	target_dir=$(dirname "$target")
	mkdir -p "$target_dir"

	# 既存リンクの処理
	if [[ -L "$target" ]]; then
		local current_target
		current_target=$(readlink "$target")
		if [[ "$current_target" == "$source" ]]; then
			log_info "シンボリックリンクは既に正しく設定されています: $target"
			return 0
		fi
		if [[ "$force" == "true" ]]; then
			rm "$target"
			log_info "既存のシンボリックリンクを削除しました: $target"
		else
			log_warning "シンボリックリンクが既に存在します: $target"
			return 1
		fi
	elif [[ -e "$target" ]]; then
		if [[ "$force" == "true" ]]; then
			rm -rf "$target"
			log_info "既存のファイル/ディレクトリを削除しました: $target"
		else
			log_warning "ファイルが既に存在します: $target"
			return 1
		fi
	fi

	# シンボリックリンクの作成（既存は手前で削除済みのため -f 不要）
	ln -s "$source" "$target"
	log_success "シンボリックリンクを作成しました: $target -> $source"
}

# プログレスバー
show_progress() {
	local current="$1"
	local total="$2"
	local description="$3"

	local percentage=$((current * 100 / total))
	local bar_length=20
	local filled_length=$((percentage * bar_length / 100))

	local bar=""
	for ((i = 0; i < filled_length; i++)); do
		bar+="█"
	done
	for ((i = filled_length; i < bar_length; i++)); do
		bar+="░"
	done

	printf "\r${CYAN}[%s] %d%% (%d/%d) %s${NC}" "$bar" "$percentage" "$current" "$total" "$description"

	if [[ "$current" -eq "$total" ]]; then
		echo
	fi
}

# 実行時間の測定
measure_time() {
	local start_time
	start_time=$(date +%s)

	"$@"

	local end_time
	end_time=$(date +%s)
	local duration=$((end_time - start_time))

	log_info "実行時間: ${duration}秒"
}

# 一時ファイルのクリーンアップ
cleanup_temp_files() {
	if [[ -n "${DOTFILES_ARCH_INFO_FILE:-}" && -f "$DOTFILES_ARCH_INFO_FILE" ]]; then
		rm -f "$DOTFILES_ARCH_INFO_FILE"
		log_info "一時ファイルをクリーンアップしました"
	fi
}

# スクリプト終了時のクリーンアップ関数を設定
setup_cleanup_trap() {
	trap cleanup_temp_files EXIT
}

# アーキテクチャ情報の保存（環境変数方式）
save_arch_info() {
	local homebrew_prefix arch
	homebrew_prefix=$(get_homebrew_prefix)
	arch=$(uname -m)

	# 環境変数に直接設定（ファイルを介さない安全な方式）
	export DOTFILES_HOMEBREW_PREFIX="$homebrew_prefix"
	export DOTFILES_ARCH="$arch"

	# 子プロセスに渡す必要がある場合のみ、安全な一時ファイルを使用
	DOTFILES_ARCH_INFO_FILE=$(mktemp "${TMPDIR:-/tmp}/dotfiles_arch_XXXXXX.sh")
	export DOTFILES_ARCH_INFO_FILE
	# printf %q でシェル安全にエスケープし、クォートheredocで展開を防止
	{
		echo '#!/usr/bin/env bash'
		printf 'export HOMEBREW_PREFIX=%q\n' "$homebrew_prefix"
		printf 'export ARCH=%q\n' "$arch"
	} >"$DOTFILES_ARCH_INFO_FILE"
	chmod 600 "$DOTFILES_ARCH_INFO_FILE"
	log_info "アーキテクチャ情報を保存しました: $arch"
}

# バックアップ作成
create_backup() {
	local file_path="$1"
	local backup_dir="${HOME}/.dotfiles_backup"

	# dotfiles管理下のシンボリックリンクはバックアップ不要
	if [[ -L "$file_path" ]]; then
		local link_target
		link_target=$(readlink "$file_path" 2>/dev/null || true)
		local dotfiles_root
		dotfiles_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
		if [[ "$link_target" == "$dotfiles_root"/* ]]; then
			return 0
		fi
	fi

	if [[ -e "$file_path" ]]; then
		# ディレクトリ構造を保持して衝突を防止
		# 例: ~/.config/nvim -> ~/.dotfiles_backup/.config/nvim
		local relative_path="${file_path#"$HOME"/}"
		local backup_path="$backup_dir/$relative_path"

		if [[ "$DRYRUN_MODE" == "true" ]]; then
			log_dryrun "バックアップ作成: $file_path -> $backup_path"
			return 0
		fi

		# 既存バックアップがあれば上書きしない（初回オリジナル保護）
		if [[ -e "$backup_path" ]]; then
			log_info "バックアップは既に存在します（スキップ）: $backup_path"
			return 0
		fi

		mkdir -p "$(dirname "$backup_path")" || {
			log_warning "バックアップディレクトリ作成失敗: $(dirname "$backup_path")"
			return 1
		}
		if ! cp -r "$file_path" "$backup_path"; then
			log_warning "バックアップ作成失敗: $file_path"
			return 1
		fi
		log_info "バックアップを作成しました: $backup_path"
	fi
}
