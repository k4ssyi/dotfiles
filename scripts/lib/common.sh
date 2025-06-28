#!/usr/bin/env bash

# 共通関数ライブラリ
# dotfilesプロジェクト全体で使用される共通機能を提供

# 厳密なエラーハンドリング
set -euo pipefail

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

	# シンボリックリンクの作成
	ln -sf "$source" "$target"
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
	if [[ -f "/tmp/dotfiles_arch_info.sh" ]]; then
		rm -f "/tmp/dotfiles_arch_info.sh"
		log_info "一時ファイルをクリーンアップしました"
	fi
}

# スクリプト終了時のクリーンアップ関数を設定
setup_cleanup_trap() {
	trap cleanup_temp_files EXIT
}

# アーキテクチャ情報の保存
save_arch_info() {
	local homebrew_prefix
	homebrew_prefix=$(get_homebrew_prefix)
	cat >/tmp/dotfiles_arch_info.sh <<EOF
#!/usr/bin/env bash
export HOMEBREW_PREFIX="$homebrew_prefix"
export ARCH="$(uname -m)"
EOF
	log_info "アーキテクチャ情報を保存しました: $(uname -m)"
}

# バックアップ作成
create_backup() {
	local file_path="$1"
	local backup_dir="${HOME}/.dotfiles_backup"

	if [[ -e "$file_path" ]]; then
		if [[ "$DRYRUN_MODE" == "true" ]]; then
			log_dryrun "バックアップ作成: $file_path -> $backup_dir/$(basename "$file_path").$(date +%Y%m%d_%H%M%S)"
			return 0
		fi

		mkdir -p "$backup_dir"
		backup_path="$backup_dir/$(basename "$file_path").$(date +%Y%m%d_%H%M%S)"
		cp -r "$file_path" "$backup_path"
		log_info "バックアップを作成しました: $backup_path"
	fi
}
