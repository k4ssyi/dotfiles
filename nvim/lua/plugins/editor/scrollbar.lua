return {
  "petertriho/nvim-scrollbar",
  opts = function(_, opts)
    -- Catppuccinのカラーパレットを取得
    local colors = require("catppuccin.palettes").get_palette "mocha"

    require("astrocore").extend_tbl(opts, {
      -- Catppuccin Mochaカラー対応
      handle = {
        color = colors.surface1,
      },
      marks = {
        Error = { color = colors.red },
        Warn = { color = colors.yellow },
        Info = { color = colors.sky },
        Hint = { color = colors.teal },
        Search = { color = colors.yellow },
        GitAdd = { color = colors.green },
        GitChange = { color = colors.blue },
        GitDelete = { color = colors.red },
      },
    })
  end,
  config = function(_, opts)
    require("scrollbar").setup(opts)
    -- Gitsignsハンドラーの設定
    if require("astrocore").is_available "gitsigns.nvim" then require("scrollbar.handlers.gitsigns").setup() end
    -- 検索ハンドラーの設定
    if require("astrocore").is_available "nvim-hlslens" then require("scrollbar.handlers.search").setup() end
  end,
}
