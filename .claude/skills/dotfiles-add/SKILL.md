---
name: dotfiles-add
description: "dotfilesリポジトリにツール設定を追加するワークフロースキル。設定ディレクトリ作成からinstallスクリプト作成、install.shへの登録、ドライラン検証までを一貫して実行する。This skill should be used when the user asks to 'dotfiles追加', 'ツール設定追加', or wants to add a new tool configuration to the dotfiles repository."
disable-model-invocation: true
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Dotfiles Add - Tool Configuration Workflow

dotfilesリポジトリに新しいツール設定を追加する際の標準ワークフロー。

## Workflow

### 1. 事前確認
- 追加するツール名と設定ファイルの場所をユーザーに確認
- 既存の設定ファイルがあるか `ls -la` で確認
- 類似のinstallスクリプトを参考として読む

### 2. 設定ディレクトリ作成
- リポジトリルートに `<tool>/` ディレクトリを作成
- 既存の設定ファイルをコピーまたは新規作成

### 3. installスクリプト作成
- `scripts/install-<tool>.sh` を作成
- `references/conventions.md` のテンプレートに従う
- 必須パターン: `source common.sh`, `setup_cleanup_trap`, `ensure_dotfiles_root`
- `create_symlink()` でシンボリックリンクを作成
- `DRYRUN_MODE` 対応

### 4. install.sh登録
- `install.sh` の `scripts_to_run` 配列に追加
- フォーマット: `"scripts/install-<tool>.sh:<ツール名>設定"`
- 適切な位置に挿入（関連ツールの近くに配置）

### 5. ドライラン検証
- `./scripts/install-<tool>.sh --dry-run` を実行
- エラーがないことを確認
- 冪等性テスト: 2回実行して2回目がスキップされることを確認

## Reference

詳細な規約とテンプレートは `references/conventions.md` を Read ツールで参照すること。
