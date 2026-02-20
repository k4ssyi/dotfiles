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
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- fzf-nativeのセットアップ
  },
  opts = function(_, opts)
    local utils = require("utils")
    
    -- デフォルト設定を定義
    local default_config = {
      defaults = {
        git_worktrees = vim.g.git_worktrees,
        prompt_prefix = "🔍 ",
        selection_caret = " ",
        entry_prefix = "  ",
        border = true,
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        path_display = { "smart" }, -- ファイル名を先頭に表示
        winblend = 10,
        -- CLI用 ripgrep/config とオプション重複あり。--no-config で独立管理（外部設定変更の影響排除）
        vimgrep_arguments = {
          "rg",
          "--no-config",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob", "!.git/",
        },
        preview = {
          hide_on_startup = false,
        },
        file_ignore_patterns = {
          ".git/",
          "node_modules/",
          "dist/",
          "vendor/",
        },
      },
      pickers = {
        find_files = {
          find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
      },
    }
    
    -- utils.safe_mergeを使用して設定を安全にマージ
    return utils.safe_merge(utils.safe_merge(opts or {}, default_config), {
      defaults = utils.safe_merge(opts and opts.defaults or {}, default_config.defaults)
    })
  end,
  config = function(plugin, opts)
    -- デフォルトのAstroNvim telescope設定を呼び出し
    require("astronvim.plugins.configs.telescope")(plugin, opts)
    
    -- 追加のカスタム設定を適用
    local telescope = require("telescope")
    telescope.setup(opts)
    
    -- Telescopeバッファが表示されたときのイベントハンドラを追加
    vim.api.nvim_create_autocmd("User", {
      pattern = "TelescopePreviewerLoaded",
      callback = function()
        vim.api.nvim_buf_set_option(0, "number", true) -- 行番号を有効化
        vim.api.nvim_buf_set_option(0, "relativenumber", false) -- 相対行番号を無効化
      end,
    })
  end,
}