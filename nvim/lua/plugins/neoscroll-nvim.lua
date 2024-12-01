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
      -- easing_function = "quadratic",
      performance_mode = true,
      easing_function = "linear",
      mappings = { "<C-u>", "<C-d>" }, -- Remove <C-e> from the default mappings
      -- pre_hook = function(info)
      --   if info == "cursorline" then vim.wo.cursorline = false end
      -- end,
      -- post_hook = function(info)
      --   if info == "cursorline" then vim.wo.cursorline = true end
      -- end,
    }
    local keymap = {
      ["<C-u>"] = function() neoscroll.ctrl_u { duration = 100 } end,
      ["<C-d>"] = function() neoscroll.ctrl_d { duration = 100 } end,
    }
    local modes = { "n", "v", "x" }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end
    -- キーマップ設定用のヘルパー関数
    -- local function map(mode, lhs, rhs, opts)
    --   local options = { noremap = true, silent = true }
    --   if opts then options = vim.tbl_extend("force", options, opts) end
    --   vim.keymap.set(mode, lhs, rhs, options)
    -- end

    -- 新しい署名を使用したカスタムマッピング
    -- map("n", "<C-u>", function() neoscroll.scroll(-vim.wo.scroll, { duration = 5 }) end)
    -- map("n", "<C-d>", function() neoscroll.scroll(vim.wo.scroll, { duration = 5 }) end)
  end,
}
