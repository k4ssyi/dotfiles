# Neovim Configuration

AstroNvim v4ベースのNeovim設定。lazy.nvimでプラグイン管理。

## アーキテクチャ

```
nvim/
├── init.lua                 # エントリーポイント（lazy.nvim bootstrap）
├── lua/
│   ├── lazy_setup.lua       # lazy.nvim + AstroNvimの初期化とimport定義
│   ├── community.lua        # AstroCommunityプラグインパックの選択
│   ├── polish.lua           # 起動後の追加処理（mise PATH設定）
│   ├── utils.lua            # 共通ユーティリティ（アイコン定数、キーマップヘルパー）
│   ├── config/              # AstroNvimモジュール設定
│   │   ├── astrocore.lua    # -> config/core/* に委譲
│   │   ├── astrolsp.lua     # -> config/lsp/* に委譲
│   │   ├── astroui.lua      # -> config/ui/* に委譲
│   │   ├── core/            # エディタ基本設定
│   │   │   ├── options.lua      # vim.opt設定
│   │   │   ├── mappings.lua     # キーマッピング
│   │   │   ├── autocmds.lua     # 自動コマンド
│   │   │   ├── features.lua     # 機能ON/OFF、診断表示
│   │   │   ├── on_keys.lua      # キー入力時コールバック
│   │   │   ├── rooter.lua       # プロジェクトルート検出
│   │   │   └── sessions.lua     # セッション管理
│   │   ├── lsp/             # LSP設定
│   │   │   ├── servers.lua      # 有効化するLSPサーバー一覧
│   │   │   ├── server_config.lua # サーバー個別設定（vtsls, biome, eslint）
│   │   │   ├── formatting.lua   # 保存時フォーマット設定
│   │   │   ├── on_attach.lua    # LSPアタッチ時の処理
│   │   │   ├── mappings.lua     # LSP関連キーマッピング
│   │   │   ├── autocmds.lua     # LSP関連自動コマンド
│   │   │   └── features.lua     # コードレンズ、インレイヒント等
│   │   └── ui/              # UI設定
│   │       ├── colorscheme.lua  # カラースキーム（Catppuccin Mocha）
│   │       ├── icons.lua        # アイコン定義
│   │       ├── highlights.lua   # ハイライトグループ上書き
│   │       └── status.lua       # heirline変数カスタマイズ
│   └── plugins/             # 個別プラグイン定義
│       ├── editor/          # エディタ機能拡張
│       │   ├── oil.lua          # ファイルエクスプローラー（メイン）
│       │   ├── neo-tree.lua     # 無効化済み（oil.nvimに移行済み）
│       │   ├── telescope.lua    # ファジーファインダー
│       │   ├── treesitter.lua   # シンタックスハイライト
│       │   ├── neocodeium.lua   # AI補完
│       │   └── ...
│       ├── git/             # Git連携
│       │   ├── gitsigns.lua     # Git差分表示
│       │   ├── lazygit.lua      # LazyGit統合
│       │   ├── gitlinker.lua    # GitHub URL生成
│       │   └── git-conflict.lua # コンフリクト解決
│       ├── lsp/             # LSP関連プラグイン
│       │   ├── mason.lua        # LSPサーバー自動インストール
│       │   ├── none-ls.lua      # 外部フォーマッタ/リンター統合
│       │   └── typescript-tools.lua
│       └── ui/              # UI拡張
│           ├── noice.lua        # コマンドラインUI
│           └── heirline/        # ステータスライン
│               ├── init.lua
│               └── config/
│                   ├── statusline.lua
│                   ├── winbar.lua
│                   └── components/  # statusline構成要素
├── after/queries/           # TreeSitterカスタムクエリ
├── lazy-lock.json           # プラグインバージョンロック
├── selene.toml              # Luaリンター設定
└── .stylua.toml             # Luaフォーマッター設定
```

## 設計パターン

### 委譲パターン（config/）

AstroNvimの3つのコアモジュールは薄いラッパーで、実際の設定は子ディレクトリに分離:

```
astrocore.lua  -- require("config.core.options"), require("config.core.mappings") ...
astrolsp.lua   -- require("config.lsp.servers"), require("config.lsp.formatting") ...
astroui.lua    -- require("config.ui.colorscheme"), require("config.ui.icons") ...
```

設定を変更する際は `astrocore.lua` ではなく `config/core/*.lua` を編集する。

### lazy.nvimのimport

`lazy_setup.lua` で import パスを定義:

```lua
{ import = "config" }       -- config/astrocore.lua, astrolsp.lua, astroui.lua
{ import = "community" }    -- community.lua
{ import = "plugins.git" }  -- plugins/git/*.lua
{ import = "plugins.editor" }
{ import = "plugins.lsp" }
{ import = "plugins.ui" }
{ import = "plugins.ui.heirline" }
```

プラグインを追加する場合、対応するカテゴリの `plugins/<category>/` にファイルを作成すれば自動的にimportされる。

### LSPフォーマッタ優先順位

プロジェクトの設定ファイルに基づいて自動判定:

1. `biome.json` / `biome.jsonc` があれば **Biome** (LSP)
2. `.prettierrc*` があれば **Prettier** (none-ls経由)
3. `.eslintrc*` / `eslint.config.*` があれば **ESLint** (LSP、Biome不在時のみ)

この排他ロジックは `astrolsp.lua` の handlers と `none-ls.lua` の condition で実装。

## 主要キーマップ

| キー | モード | 動作 |
|------|--------|------|
| `<Space>` | n | Leader |
| `,` | n | Local leader |
| `<Leader>e` | n | Oil.nvim（ファイラー） |
| `H` / `L` | n | 前/次のバッファ |
| `jj` | i | Escapeの代替 |
| `\` / `-` | n | 縦分割 / 横分割 |
| `<C-a>` / `<C-e>` | n,i,v | 行頭 / 行末 |
| `<Leader>bd` | n | バッファをピッカーで閉じる |
| `<Leader>gnd` | n | Diffviewを開く |
