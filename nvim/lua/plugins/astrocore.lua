--[[
AstroCore - AstroNvimのコア設定モジュール

@概要
  - キーマッピング、Vimオプション、自動コマンドなどの中心的な設定を行うためのモジュールです。
  - 設定内容は `:h astrocore` でドキュメントを参照できます。
  - Lua言語サーバー（:LspInstall lua_ls）の導入を強く推奨します。これにより補完やドキュメント参照が可能になります。

@主な仕様
  - features: AstroNvimのコア機能の有効/無効化
  - diagnostics: 診断表示の設定
  - autocmds: 自動コマンドの設定
  - options: Vimオプションの一括設定
  - mappings: キーマッピングの一括設定
  - on_keys: キー入力時の関数実行設定
  - rooter: プロジェクトルート検出の設定
  - sessions: セッション管理の設定

@制限事項
  - 設定内容によっては他プラグインと競合する場合があります。
  - mapleader/maplocalleaderは `lua/lazy_setup.lua` で事前に設定してください。

  @参考
  - https://github.com/AstroNvim/AstroNvim
  - :h astrocore

]]

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- AstroNvimのコア機能設定
    features = {
      large_buf = { size = 1024 * 1024, lines = 10000 }, -- 大きなバッファの閾値（サイズ・行数）
      autopairs = true, -- 起動時に自動ペア補完を有効化
      cmp = true, -- 起動時に補完機能を有効化
      diagnostics_mode = 3, -- 診断表示モード（0:無効, 1:サイン/仮想テキストなし, 2:仮想テキストなし, 3:全て表示）
      highlighturl = true, -- 起動時にURLをハイライト
      notifications = true, -- 起動時に通知機能を有効化
    },
    -- 診断表示の設定（vim.diagnostics.config({...})に渡される）
    diagnostics = {
      virtual_text = true, -- 仮想テキストで診断を表示
      underline = true, -- 下線で診断を表示
    },
    -- 自動コマンドの設定
    autocmds = {
      -- 最初のキーはaugroup名
      highlighturl = {
        -- 設定する自動コマンドのリスト
        {
          -- トリガーとなるイベント
          event = { "VimEnter", "FileType", "BufEnter", "WinEnter" },
          -- その他のautocmdオプション
          desc = "URLハイライト",
          callback = function() require("astrocore").set_url_match() end,
        },
      },
    },
    -- Vimオプションの一括設定
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- 相対行番号を無効化
        number = true, -- 行番号を有効化
        spell = false, -- スペルチェックを無効化
        signcolumn = "auto", -- サインカラムを自動表示
        swapfile = false, -- スワップファイルを無効化
        wrap = true, -- テキストの折り返しを有効化
      },
      g = { -- vim.g.<key>
        -- グローバル変数の設定（vim.g）
        -- mapleader/maplocalleaderはAstroNvimのoptsまたは`lazy.setup`前に設定してください
        -- 詳細は`lua/lazy_setup.lua`を参照
      },
    },
    -- キーマッピングの一括設定
    -- キーコードはvimドキュメントの表記に従い、大文字小文字を区別します（例: <Leader>）
    mappings = {
      -- 最初のキーはモード
      n = {
        -- 行頭・行末への移動
        ["<C-a>"] = { "^", noremap = true, desc = "行頭に移動" },
        ["<C-e>"] = { "$", noremap = true, silent = true, desc = "行末に移動" },

        -- 分割ウィンドウのリサイズ（Altキー）
        ["<A-j>"] = { ":resize +2<CR>", desc = "ウィンドウを上に拡大" },
        ["<A-k>"] = { ":resize -2<CR>", desc = "ウィンドウを下に縮小" },
        ["<A-l>"] = { ":vertical resize +2<CR>", desc = "ウィンドウを右に拡大" },
        ["<A-h>"] = { ":vertical resize -2<CR>", desc = "ウィンドウを左に縮小" },

        -- xでヤンクしない
        x = { '"_x', desc = "xでヤンクしない" },

        -- 2つ目のキーはマッピングの左辺
        ["\\"] = { "<cmd>vsplit<cr>", desc = "縦分割" },
        ["-"] = { "<cmd>split<cr>", desc = "横分割" },

        -- バッファタブの移動
        ["L"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "次のバッファへ" },
        ["H"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "前のバッファへ" },

        -- "Buffer"グループのマッピング
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "タブラインからバッファを閉じる",
        },
        -- プラグイン用マッピング
        ["<leader>gnd"] = { "<cmd>DiffviewOpen<cr>", desc = "Git差分ビューを開く" },
      },
      -- 挿入モード
      i = {
        ["jj"] = { "<Esc>", desc = "挿入モードを抜ける", silent = true, noremap = true },
        ["ｊｊ"] = { "<Esc>", desc = "挿入モードを抜ける", silent = true, noremap = true },
        -- 行末にカーソル移動
        ["<C-e>"] = { "<Esc>A", desc = "行末に移動" },
        -- 行頭にカーソル移動
        ["<C-a>"] = { "<Esc>I", desc = "行頭に移動" },
      },
      -- ビジュアルモード
      v = {
        x = { '"_x', desc = "xでヤンクしない" },
        ["<C-a>"] = { "^", desc = "行頭に移動" },
        ["<C-e>"] = { "$", desc = "行末に移動" },
      },
    },
    -- キー入力時に実行する関数の設定
    on_keys = {
      -- 最初のキーは名前空間
      auto_hlsearch = {
        -- キー入力時に実行する関数のリスト
        function(char) -- 検索中以外は自動的にhlsearchを無効化
          if vim.fn.mode() == "n" then
            local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
            if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
          end
        end,
      },
    },
    -- プロジェクトルート検出の設定（:AstroRootInfoで状態確認可能）
    rooter = {
      -- 優先順に検出方法をリスト
      detector = {
        "lsp", -- 最優先は稼働中のLSPからワークスペース取得
        { ".git", "_darcs", ".hg", ".bzr", ".svn" }, -- 次にバージョン管理ディレクトリを探索
        { "lua", "MakeFile", "package.json" }, -- 最後に既知のプロジェクトルートファイルを探索
      },
      -- ルート検出から除外するもの
      ignore = {
        servers = {}, -- 除外するLSPサーバー名リスト（例: { "efm" }）
        dirs = {}, -- 除外するディレクトリパターン（例: { "~/.cargo/*" }）
      },
      -- 作業ディレクトリを自動で更新（手動更新は:AstroRoot）
      autochdir = false,
      -- 作業ディレクトリの変更範囲（"global"|"tab"|"win"）
      scope = "global",
      -- 作業ディレクトリ変更時に毎回通知を表示
      notify = false,
    },
    -- セッション管理（Resessionによる）の設定
    sessions = {
      -- 自動保存の設定
      autosave = {
        last = true, -- 最後のセッションを自動保存
        cwd = true, -- 作業ディレクトリごとにセッションを自動保存
      },
      -- セッション保存時に無視するパターン
      ignore = {
        dirs = {}, -- セッションを無視する作業ディレクトリ
        filetypes = { "gitcommit", "gitrebase" }, -- セッションを無視するファイルタイプ
        buftypes = {}, -- セッションを無視するバッファタイプ
      },
    },
  },
}
