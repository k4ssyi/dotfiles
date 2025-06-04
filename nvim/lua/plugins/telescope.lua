--[[
Telescope - ファジーファインダー/検索プラグイン設定

@概要
  - ファイル・バッファ・LSPシンボルなど様々なリソースをインクリメンタル検索できます。
  - fzf-native拡張や各種UIカスタマイズが可能です。

@主な仕様
  - prompt_prefix, selection_caret, entry_prefix: UIの装飾
  - extensions.fzf: fzf拡張の有効化
  - file_ignore_patterns: 検索除外パターン
  - opts.defaults: デフォルト設定のマージ

@制限事項
  - fzf-native拡張はmakeコマンドによるビルドが必要です。

@参考
  - https://github.com/nvim-telescope/telescope.nvim

]]

return {
  "nvim-telescope/telescope.nvim",
  requires = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- fzf-nativeのセットアップ
  },
  opts = function(_, opts)
    -- 現在のデフォルト設定とマージするために tbl_deep_extend 関数を使用
    opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
      prompt_prefix = "🔍 ",
      selection_caret = " ",
      entry_prefix = "  ",
      border = true,
      borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      -- path_display = { "shorten" }, -- パスを短縮して表示
      path_display = { "smart" }, -- ファイル名を先頭に表示
      winblend = 10,
      preview = {
        hide_on_startup = false,
      },
    })
    opts.extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      },
    }
    opts.number = true
    opts.relativenumber = false

    -- Telescopeバッファが表示されたときのイベントハンドラを追加
    vim.api.nvim_create_autocmd("User", {
      pattern = "TelescopePreviewerLoaded",
      callback = function()
        vim.api.nvim_buf_set_option(0, "number", true) -- 行番号を有効化
        vim.api.nvim_buf_set_option(0, "relativenumber", false) -- 相対行番号を無効化
      end,
    })

    opts.file_ignore_patterns = {
      ".git/",
      "node_modules/",
      "dist/",
      "vendor/",
    }
  end,
}
