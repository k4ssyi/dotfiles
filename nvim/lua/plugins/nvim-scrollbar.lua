--[[
nvim-scrollbar - スクロールバー表示プラグイン設定

@概要
  - Neovimのウィンドウ右端にスクロールバーを表示し、カーソル位置やGit差分、診断情報などを可視化します。
  - 各種マークやハンドラで表示内容を細かく制御できます。

@主な仕様
  - handlers: gitsigns, search, aleなどの連携
  - marks: カーソル・検索・Git・診断などのマーク表示
  - excluded_buftypes/filetypes: 除外対象のバッファ・ファイルタイプ
  - autocmd: スクロールバーの描画・クリアイベント

@制限事項
  - 一部のファイルタイプやバッファでは自動的に非表示となります。

@参考
  - https://github.com/petertriho/nvim-scrollbar

]]

return {
  "petertriho/nvim-scrollbar",
  event = "User AstroFile",
  opts = function(_, opts)
    require("astrocore").extend_tbl(opts, {
      handlers = {
        gitsigns = require("astrocore").is_available "gitsigns.nvim",
        search = require("astrocore").is_available "nvim-hlslens",
        ale = require("astrocore").is_available "ale",
      },
    })
    require("scrollbar").setup {
      show = true,
      show_in_active_only = false,
      set_highlights = true,
      folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
      max_lines = false, -- disables if no. of lines in buffer exceeds this
      handle = {
        text = " ",
        color = "#4f4f4f",
        cterm = nil,
        -- highlight = "CursorColumn",
        hide_if_all_visible = false, -- Hides handle if all lines are visible
      },
      marks = {
        Cursor = {
          -- text = "•",
          text = "─",
          priority = 0,
          color = "#7f7f7f",
          cterm = nil,
          -- highlight = "Normal",
        },
        Search = {
          text = { "-", "=" },
          priority = 1,
          color = nil,
          cterm = nil,
          highlight = "Search",
        },
        Error = {
          text = { "-", "=" },
          priority = 2,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextError",
        },
        Warn = {
          text = { "-", "=" },
          priority = 3,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextWarn",
        },
        Info = {
          text = { "-", "=" },
          priority = 4,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextInfo",
        },
        Hint = {
          text = { "-", "=" },
          priority = 5,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextHint",
        },
        Misc = {
          text = { "-", "=" },
          priority = 6,
          color = nil,
          cterm = nil,
          highlight = "Normal",
        },
        GitAdd = {
          text = "┆",
          priority = 7,
          color = nil,
          cterm = nil,
          highlight = "GitSignsAdd",
        },
        GitChange = {
          text = "┆",
          priority = 7,
          color = nil,
          cterm = nil,
          highlight = "GitSignsChange",
        },
        GitDelete = {
          text = "▁",
          priority = 7,
          color = nil,
          cterm = nil,
          highlight = "GitSignsDelete",
        },
      },
      excluded_buftypes = {
        "terminal",
      },
      excluded_filetypes = {
        "prompt",
        "TelescopePrompt",
        "noice",
        "alpha",
        "NvimTree",
        "",
      },
      autocmd = {
        render = {
          "BufWinEnter",
          "TabEnter",
          "TermEnter",
          "WinEnter",
          "CmdwinLeave",
          "TextChanged",
          "VimResized",
          "WinScrolled",
        },
        clear = {
          "BufWinLeave",
          "TabLeave",
          "TermLeave",
          "WinLeave",
        },
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true,
        handle = true,
        search = true,
        ale = true,
      },
    }

    return opts
  end,
}
