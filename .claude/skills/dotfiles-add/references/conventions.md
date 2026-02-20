# Dotfiles Conventions

## Install Script Template

`scripts/install-claude-conf.sh` をモデルとした標準テンプレート:

```bash
#!/usr/bin/env bash

# <ツール名>設定セットアップスクリプト
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

log_info "<ツール名>設定のセットアップを開始します"

# dotfilesディレクトリからの実行を確認
ensure_dotfiles_root

# ソースパスの定義
source_dir="$(pwd)/<tool>"

# ソースの存在確認
if [[ ! -d "$source_dir" ]]; then
	handle_error "<ツール名>設定ディレクトリが見つかりません: $source_dir"
fi

# 既存設定のバックアップ
log_step "既存設定のバックアップを作成中..."
create_backup "${HOME}/.<tool-config-path>"

# シンボリックリンクの作成
log_step "設定ファイルのリンクを作成中..."
create_symlink "$source_dir/<config-file>" "${HOME}/.<tool-config-path>" true

log_success "<ツール名>設定のセットアップが完了しました"
```

## common.sh 共通関数仕様

### `create_symlink(source, target, force)`

| 引数 | 説明 |
|------|------|
| `source` | リンク元（dotfilesリポジトリ内のパス）。絶対パス |
| `target` | リンク先（`$HOME`配下のパス）。絶対パス |
| `force` | `true`: 既存ファイル/リンクを削除して上書き。`false`（デフォルト）: 既存があればエラー |

動作:
- `DRYRUN_MODE=true` の場合はログ出力のみ
- 既に正しいリンク先を指している場合はスキップ（冪等）
- `force=true` の場合のみ既存を削除

### `create_backup(file_path)`

- dotfiles管理下のシンボリックリンクはスキップ
- ディレクトリ構造を保持してバックアップ（`~/.dotfiles_backup/` 配下）
- 既存バックアップがあれば上書きしない（初回オリジナル保護）

### `command_exists(command)`

`command -v` によるコマンド存在確認。`which` の代わりに使用する。

### その他必須呼び出し

- `setup_cleanup_trap`: 一時ファイルのクリーンアップ用trapを設定
- `ensure_dotfiles_root`: dotfilesディレクトリからの実行を確認

## scripts_to_run 配列フォーマット

`install.sh` 内の配列に追加する:

```bash
scripts_to_run=(
	"scripts/setup-brew.sh:Homebrewのセットアップ"
	"scripts/install-brew-component.sh:Homebrewパッケージのインストール"
	# ... 他のスクリプト ...
	"scripts/install-<tool>.sh:<ツール名>設定"    # 追加
	# ... 他のスクリプト ...
)
```

- フォーマット: `"<スクリプトパス>:<日本語説明>"`
- コロン(`:`)がデリミタ。説明にコロンを含めないこと
- 関連するツールの近くに配置する

## Naming Conventions

- スクリプト名: `install-<tool>.sh`（ハイフン区切り、小文字）
- 設定ディレクトリ名: `<tool>/`（ツール名そのまま、小文字）
- ログメッセージ: 日本語で記述
