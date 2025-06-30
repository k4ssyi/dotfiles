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
  event = "VeryLazy",
  opts = {
    hide_cursor = true,
    stop_eof = true,
    respect_scrolloff = false,
    cursor_scrolls_alone = true,
    performance_mode = true,
    easing_function = "linear",
    mappings = { "<C-u>", "<C-d>" },
    -- 大きいファイル用の最適化設定
    pre_hook = function()
      -- ファイルサイズまたは行数が大きい場合はスムーススクロールを無効化
      local line_count = vim.api.nvim_buf_line_count(0)
      local file_size = vim.fn.getfsize(vim.fn.expand "%")

      if line_count > 5000 or file_size > 1024 * 1024 then -- 5000行または1MB以上
        return false -- スムーススクロールを無効化
      end
    end,
  },
  config = function(_, opts)
    local neoscroll = require "neoscroll"
    neoscroll.setup(opts)

    -- 動的なスクロール速度調整
    vim.defer_fn(function()
      local function get_scroll_duration()
        local line_count = vim.api.nvim_buf_line_count(0)
        if line_count > 10000 then
          return 50 -- 大きいファイルは高速
        elseif line_count > 5000 then
          return 75 -- 中程度のファイル
        else
          return 100 -- 小さいファイルはスムーズ
        end
      end

      local keymap = {
        ["<C-u>"] = function()
          local duration = get_scroll_duration()
          neoscroll.ctrl_u { duration = duration }
        end,
        ["<C-d>"] = function()
          local duration = get_scroll_duration()
          neoscroll.ctrl_d { duration = duration }
        end,
      }

      local modes = { "n", "v", "x" }
      for key, func in pairs(keymap) do
        vim.keymap.set(modes, key, func, { noremap = true, silent = true })
      end
    end, 100)
  end,
}
