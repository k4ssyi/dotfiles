--[[
neoscroll.nvim - スムーズスクロール上書き設定

@概要
  - AstroCommunityのneoscroll-nvim設定を上書きします。
  - カスタムのスクロール速度とキーマッピングを設定します。

@基本設定
  - community.luaで "astrocommunity.scrolling.neoscroll-nvim" をimport
  - ここでカスタム設定を上書き

@制限事項
  - 他のスクロール系プラグインと競合する場合があります。

@参考
  - https://github.com/karb94/neoscroll.nvim

]]

return {
  "karb94/neoscroll.nvim",
  opts = {
    hide_cursor = true,
    stop_eof = true,
    respect_scrolloff = false,
    cursor_scrolls_alone = true,
    performance_mode = true,
    easing_function = "linear",
    mappings = { "<C-u>", "<C-d>" }, -- Remove <C-e> from the default mappings
  },
  config = function(_, opts)
    local neoscroll = require("neoscroll")
    neoscroll.setup(opts)

    -- カスタムキーマップの設定
    vim.defer_fn(function()
      local keymap = {
        ["<C-u>"] = function() neoscroll.ctrl_u { duration = 100 } end,
        ["<C-d>"] = function() neoscroll.ctrl_d { duration = 100 } end,
      }
      local modes = { "n", "v", "x" }
      for key, func in pairs(keymap) do
        vim.keymap.set(modes, key, func, { noremap = true, silent = true })
      end
    end, 100)
  end,
}
