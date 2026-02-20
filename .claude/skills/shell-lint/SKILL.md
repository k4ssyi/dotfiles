---
name: shell-lint
description: "シェルスクリプトの品質チェックスキル。shellcheckによる静的解析とプロジェクト固有の規約チェックを二段階で実行する。This skill should be used when shell scripts are modified, created, or when the user asks for 'shell-lint', 'シェルチェック', or 'スクリプト検証'."
allowed-tools: Bash(shellcheck *), Read, Grep, Glob
---

# Shell Lint - Script Quality Check

shellcheckによる静的解析 + プロジェクト規約の二段階チェック。

## Workflow

### Stage 1: shellcheck

scripts/配下の全`.sh`ファイルに対して実行:

```bash
shellcheck -x -s bash scripts/**/*.sh scripts/lib/*.sh install.sh
```

- `-x`: source先のファイルも追跡
- `-s bash`: bashとして解析

severity別に結果を分類（error > warning > info > style）。

### Stage 2: Project Convention Check

以下のプロジェクト規約に違反していないかをGrepとReadで確認:

#### 必須パターン（installスクリプト対象）

| チェック項目 | grepパターン | 必須 |
|---|---|---|
| common.sh source | `source.*lib/common.sh` | Yes |
| setup_cleanup_trap | `setup_cleanup_trap` | Yes |
| ensure_dotfiles_root | `ensure_dotfiles_root` | Yes |
| shebang | `#!/usr/bin/env bash` | Yes |
| --dry-run対応 | `DRYRUN_MODE` | Yes |

#### 禁止パターン

| チェック項目 | grepパターン | 理由 |
|---|---|---|
| 直接ln -sf | `ln -sf` (create_symlink外) | `create_symlink()` を使用すること |
| 直接which | `which ` | `command_exists()` を使用すること |
| set -e単独 | `set -e$` (common.sh外) | common.sh経由で自動適用 |

### Output Format

結果を以下の形式で報告:

```
## Shell Lint Results

### shellcheck
- errors: N件
- warnings: N件
- info: N件

### Project Conventions
- violations: N件
  - [file:line] <violation description>

### Summary
PASS / FAIL (violation count)
```

## Notes

- `scripts/lib/common.sh` 自体はチェック対象だがconvention checkの「必須パターン」は除外（ライブラリ自身がsourceする必要はない）
- `install.sh` はルート直下にあるため `scripts/` とは別にチェック
