# Dotfiles Project

macOS向けdotfilesリポジトリ。シェル環境・エディタ・ターミナル・ウィンドウマネージャ等の設定を一元管理する。

- **対象OS**: macOS (Apple Silicon / Intel)
- **主要ツール**: Zsh, Neovim, Ghostty, tmux, Starship, Hammerspoon, Karabiner-Elements
- **パッケージ管理**: Homebrew, mise (旧rtx)

## ディレクトリ構造

| ディレクトリ | 役割 |
|---|---|
| `scripts/` | installスクリプト群。`lib/common.sh`に共通関数 |
| `scripts/lib/` | 共通ライブラリ (`common.sh`) |
| `claude/` | Claude Code設定 (-> `~/.claude/` にシンボリックリンク) |
| `claude/agents/` | カスタムagent定義。`references/`に詳細資料を分離 |
| `claude/skills/` | Personal scope skills (全プロジェクト共通) |
| `.claude/skills/` | Project scope skills (このリポジトリ専用) |
| `zsh/` | Zsh設定 (`zshrc`, `zprofile` 等) |
| `nvim/` | Neovim設定 (lazy.nvim) |
| `ghostty/` | Ghostty設定 |
| `tmux/` | tmux設定 |
| `starship/` | Starship prompt設定 |
| `hammerspoon/` | Hammerspoon設定 |
| `karabiner/` | Karabiner-Elements設定 |
| `git/` | Git設定テンプレート |
| `alacritty/` | Alacritty設定 (レガシー) |
| `ssh/` | SSH設定テンプレート |

## シェルスクリプト規約

新しいinstallスクリプトを書く際は以下を遵守する:

- `scripts/lib/common.sh` を必ず `source`
- シンボリックリンク作成は `create_symlink(source, target, force)` を使用（直接 `ln -sf` 禁止）
- コマンド存在確認は `command_exists()` を使用（直接 `which` 禁止）
- `setup_cleanup_trap` と `ensure_dotfiles_root` を冒頭で呼び出す
- `DRYRUN_MODE` 対応必須（`--dry-run` 引数のパース含む）
- shebang: `#!/usr/bin/env bash`
- エラーハンドリング: `set -euo pipefail`（common.sh経由で自動適用）

## Claude Code設定の構成

`claude/` ディレクトリの内容は `scripts/install-claude-conf.sh` により `~/.claude/` へシンボリックリンクされる:

- `claude/CLAUDE.md` -> `~/.claude/CLAUDE.md` (global指示)
- `claude/settings.json` -> `~/.claude/settings.json`
- `claude/agents/` -> `~/.claude/agents/`
- `claude/skills/` -> `~/.claude/skills/` (personal scope)

`.claude/skills/` はproject scopeとしてこのリポジトリ内で直接管理する（シンボリックリンク不要）。

## Neovim設定の編集ガイド

AstroNvim v4 + lazy.nvim構成。詳細は `nvim/README.md` を参照。

### ファイル配置ルール

| 変更対象 | 編集先 | 注意 |
|---|---|---|
| キーマッピング追加 | `nvim/lua/config/core/mappings.lua` | `astrocore.lua` を直接編集しない |
| Vimオプション変更 | `nvim/lua/config/core/options.lua` | 同上 |
| LSPサーバー追加 | `nvim/lua/config/lsp/servers.lua` + `server_config.lua` | |
| フォーマッタ設定 | `nvim/lua/config/lsp/formatting.lua` | Biome/Prettier/ESLintの排他ロジックに注意 |
| プラグイン追加 | `nvim/lua/plugins/<category>/` に新規ファイル | lazy.nvimが自動import |
| カラースキーム変更 | `nvim/lua/config/ui/colorscheme.lua` | |
| AstroCommunityパック追加 | `nvim/lua/community.lua` | |

### 重要な制約

- `config/astrocore.lua`, `config/astrolsp.lua`, `config/astroui.lua` は委譲ファイル。設定値は子ディレクトリのファイルに書く
- `plugins/` 配下のディレクトリ名は `lazy_setup.lua` のimportパスと対応。ディレクトリ名変更時はimportも修正
- LSPフォーマッタは `biome.json` > `.prettierrc*` > `.eslintrc*` の優先順位で排他的に動作（`astrolsp.lua` handlers + `none-ls.lua` condition）
- `neo-tree.lua` は `enabled = false` で無効化済み（oil.nvimに移行済み）

## install.sh のパターン

新しいツール設定を追加する場合:
1. `scripts/install-<tool>.sh` を作成
2. `install.sh` の `scripts_to_run` 配列に `"scripts/install-<tool>.sh:<説明>"` 形式で追加
3. `./install.sh --dry-run` で動作確認
