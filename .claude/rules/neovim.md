---
paths:
  - "nvim/**/*.lua"
  - "nvim/**/*.md"
---

# Neovim設定の編集ガイド

AstroNvim v4 + lazy.nvim構成。詳細は `nvim/README.md` を参照。

## ファイル配置ルール

| 変更対象 | 編集先 | 注意 |
|---|---|---|
| キーマッピング追加 | `nvim/lua/config/core/mappings.lua` | `astrocore.lua` を直接編集しない |
| Vimオプション変更 | `nvim/lua/config/core/options.lua` | 同上 |
| LSPサーバー追加 | `nvim/lua/config/lsp/servers.lua` + `server_config.lua` | |
| フォーマッタ設定 | `nvim/lua/config/lsp/formatting.lua` | Biome/Prettier/ESLintの排他ロジックに注意 |
| プラグイン追加 | `nvim/lua/plugins/<category>/` に新規ファイル | lazy.nvimが自動import |
| カラースキーム変更 | `nvim/lua/config/ui/colorscheme.lua` | |
| AstroCommunityパック追加 | `nvim/lua/community.lua` | |

## 重要な制約

- `config/astrocore.lua`, `config/astrolsp.lua`, `config/astroui.lua` は委譲ファイル。設定値は子ディレクトリのファイルに書く
- `plugins/` 配下のディレクトリ名は `lazy_setup.lua` のimportパスと対応。ディレクトリ名変更時はimportも修正
- LSPフォーマッタは `biome.json` > `.prettierrc*` > `.eslintrc*` の優先順位で排他的に動作（`astrolsp.lua` handlers + `none-ls.lua` condition）
- `neo-tree.lua` は `enabled = false` で無効化済み（oil.nvimに移行済み）
