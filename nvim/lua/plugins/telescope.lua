return {
  "nvim-telescope/telescope.nvim",
  requires = {
    { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }, -- fzf-nativeのセットアップ
  },
  opts = function(_, opts)
    -- 現在のデフォルト設定とマージするために tbl_deep_extend 関数を使用
    opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
      -- layout_strategy = "vertical", -- 検索結果を縦に配置
      prompt_prefix = "🔍 ",
      selection_caret = " ",
      entry_prefix = "  ",
      border = true,
      borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      -- path_display = { "shorten" }, -- パスを短縮して表示
      path_display = {
        filename_first = {
          reverse_directories = false,
        },
      },
      winblend = 10,
      preview = {
        hide_on_startup = false,
      },
    })

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
