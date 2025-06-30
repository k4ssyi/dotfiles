--[[
Noice - LSPメッセージUI上書き設定

@概要
  - AstroCommunityのnoice-nvim設定を上書きします。
  - LSPのhoverとsignatureを無効化します。
  - コマンドラインを画面中央に表示します。

@基本設定
  - community.luaで "astrocommunity.utility.noice-nvim" をimport
  - ここでカスタム設定を上書き

@参考
  - https://github.com/folke/noice.nvim

]]

return {
  "folke/noice.nvim",
  opts = function(_, opts)
    -- AstroCommunityの設定を拡張
    require("astrocore").extend_tbl(opts, {
      -- LSP設定
      lsp = {
        hover = {
          enabled = false,
          silent = false,
          view = nil,
          opts = {},
        },
        signature = {
          enabled = false,
        },
      },
      -- コマンドラインを中央に表示
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        opts = {},
        format = {
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = "", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = "", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
          input = {},
        },
      },
      -- ビュー設定
      views = {
        cmdline_popup = {
          backend = "popup",
          relative = "editor",
          focusable = true,
          enter = false,
          position = {
            row = "50%",
            col = "50%",
          },
          size = {
            min_width = 60,
            width = "auto",
            height = "auto",
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
      },
    })
  end,
}
