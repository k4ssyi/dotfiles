---
paths:
  - "scripts/**/*.sh"
  - "install.sh"
---

# シェルスクリプト規約

新しいinstallスクリプトを書く際は以下を遵守する:

- `scripts/lib/common.sh` を必ず `source`
- シンボリックリンク作成は `create_symlink(source, target, force)` を使用（直接 `ln -sf` 禁止）
- コマンド存在確認は `command_exists()` を使用（直接 `which` 禁止）
- `setup_cleanup_trap` と `ensure_dotfiles_root` を冒頭で呼び出す
- `DRYRUN_MODE` 対応必須（`--dry-run` 引数のパース含む）
- shebang: `#!/usr/bin/env bash`
- エラーハンドリング: `set -euo pipefail`（common.sh経由で自動適用）

## install.sh のパターン

新しいツール設定を追加する場合:

1. `scripts/install-<tool>.sh` を作成
2. `install.sh` の `scripts_to_run` 配列に `"scripts/install-<tool>.sh:<説明>"` 形式で追加
3. `./install.sh --dry-run` で動作確認
