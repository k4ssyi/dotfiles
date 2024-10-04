return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  config = function()
    local neoscroll = require "neoscroll"

    neoscroll.setup {
      -- マッピングはここで設定しないでください
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      cursor_scrolls_alone = true,
      easing_function = "quadratic",
    }

    -- キーマップ設定用のヘルパー関数
    local function map(mode, lhs, rhs, opts)
      local options = { noremap = true, silent = true }
      if opts then options = vim.tbl_extend("force", options, opts) end
      vim.keymap.set(mode, lhs, rhs, options)
    end

    -- 新しい署名を使用したカスタムマッピング
    map("n", "<C-u>", function() neoscroll.scroll(-vim.wo.scroll, { duration = 25 }) end)
    map("n", "<C-d>", function() neoscroll.scroll(vim.wo.scroll, { duration = 25 }) end)
  end,
}
