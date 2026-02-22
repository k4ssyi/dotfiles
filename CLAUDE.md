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
| `claude/templates/` | CLAUDE.md テンプレート集（手動コピーで使用） |
| `.claude/skills/` | Project scope skills (このリポジトリ専用) |
| `zsh/` | Zsh設定 (`zshrc`, `zprofile` 等) |
| `nvim/` | Neovim設定 (lazy.nvim) |
| `ripgrep/` | ripgrep設定 (`~/.config/ripgrep/` にシンボリックリンク) |
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
- `claude/mcp.json` -> `~/.mcp.json` (グローバルMCPサーバー設定)
- `claude/agents/` -> `~/.claude/agents/`
- `claude/skills/` -> `~/.claude/skills/` (personal scope)

`.claude/skills/` はproject scopeとしてこのリポジトリ内で直接管理する（シンボリックリンク不要）。

`claude/templates/` はプロジェクト用 CLAUDE.md のテンプレート集。`~/.claude/` へはシンボリックリンクされない（手動 `cp` で各プロジェクトへ配置して使用）。

| テンプレート | 用途 |
|---|---|
| `frontend.md` | フロントエンドプロジェクト |
| `backend.md` | バックエンド API プロジェクト |
| `shell-infra.md` | シェルスクリプト / インフラ構成 |
| `ui-ux-design.md` | UI/UXデザイン作業 |
| `writing.md` | 執筆・文書作成 |
| `monorepo-root.md` | モノレポのルート CLAUDE.md |

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

## カラーテーマ (Catppuccin Mocha)

全ツールで Catppuccin Mocha に統一。テーマ変更時は以下を全て更新すること:

| ファイル | 設定方式 | 変更内容 |
|---|---|---|
| `nvim/lua/config/ui/colorscheme.lua` | プラグイン名 | 返り値の文字列を変更 |
| `nvim/lua/plugins/editor/scrollbar.lua` | `get_palette "mocha"` | パレット名を変更 |
| `nvim/lua/community.lua` | AstroCommunity import | colorschemeのimportを変更 |
| `tmux/.tmux.conf` | `@catppuccin_flavor` | フレーバー名を変更 |
| `zsh/sheldon/plugins.toml` | プラグイン参照 | github先・`use`ファイル名を変更 |
| `zsh/.zshrc` (`BAT_THEME`) | 文字列名 | テーマ名を変更 |
| `zsh/.zshrc` (`FZF_DEFAULT_OPTS`) | hexカラー直書き | 全色を手動置換 |
| `starship/starship.toml` | パレット定義 + `palette` | パレットブロックと参照名を差し替え |
| `ghostty/config` | カラースキームブロック | 色定義ブロックを差し替え |
| `alacritty/alacritty.toml` | import パス | テーマファイルパスを変更 |

検出コマンド: `grep -ri 'catppuccin\|#1e1e2e\|#313244' --include='*.lua' --include='*.toml' --include='*.zshrc' --include='config'`

## install.sh のパターン

新しいツール設定を追加する場合:

1. `scripts/install-<tool>.sh` を作成
2. `install.sh` の `scripts_to_run` 配列に `"scripts/install-<tool>.sh:<説明>"` 形式で追加
3. `./install.sh --dry-run` で動作確認
