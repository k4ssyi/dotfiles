--[[
neoscroll.nvim - スムーズスクロールプラグイン設定

@概要
  - <C-u>/<C-d>等のスクロール操作をアニメーション付きで滑らかにします。
  - カスタムマッピングや各種挙動の詳細設定が可能です。

@主な仕様
  - mappings: 有効化するスクロールキー
  - hide_cursor, stop_eof, performance_mode等の挙動制御
  - 独自のキーマップ追加例も記載

@制限事項
  - 他のスクロール系プラグインと競合する場合があります。

@参考
  - https://github.com/karb94/neoscroll.nvim

]]

return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  config = function()
    local neoscroll = require "neoscroll"

    neoscroll.setup {
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      cursor_scrolls_alone = true,
      -- easing_function = "quadratic",
      performance_mode = true,
      easing_function = "linear",
      mappings = { "<C-u>", "<C-d>" }, -- Remove <C-e> from the default mappings
    }

    local keymap = {
      ["<C-u>"] = function() neoscroll.ctrl_u { duration = 100 } end,
      ["<C-d>"] = function() neoscroll.ctrl_d { duration = 100 } end,
    }
    local modes = { "n", "v", "x" }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func, { noremap = true, silent = true })
    end
  end,
}
