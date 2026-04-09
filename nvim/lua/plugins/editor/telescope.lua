--[[
Snacks.picker - ファジーファインダー設定 (旧telescope.nvim)

@概要
  - AstroNvim v6ではsnacks.pickerがデフォルトのファジーファインダー
  - ここではプロジェクト固有のカスタマイズのみ定義

@参考
  - https://github.com/folke/snacks.nvim

]]

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = {
          hidden = true,
          ignored = false,
        },
        grep = {
          hidden = true,
        },
      },
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
          },
        },
      },
    },
  },
}
