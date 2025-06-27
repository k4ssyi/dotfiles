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
    opts = opts or {}

    -- LSP設定
    opts.lsp = vim.tbl_deep_extend("force", opts.lsp or {}, {
      hover = {
        enabled = false,
        silent = false,
        view = nil,
        opts = {},
      },
      signature = {
        enabled = false,
      },
    })

    -- コマンドラインを中央に表示
    opts.cmdline = vim.tbl_deep_extend("force", opts.cmdline or {}, {
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
    })

    opts.views = vim.tbl_deep_extend("force", opts.views or {}, {
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
    })

    return opts
  end,
}
