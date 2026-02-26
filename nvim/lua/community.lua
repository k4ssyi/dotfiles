--[[
AstroCommunity - AstroNvim公式コミュニティプラグイン集

@概要
  - AstroNvim公式コミュニティが提供する各種プラグインパックをimportできます。
  - colorscheme, scrolling, indent, git, language support等のカテゴリ別パックを柔軟に追加可能です。

@主な仕様
  - import: 必要なパックやプラグインをimportで指定
  - plugins/よりも先に読み込まれるため、上書きや拡張が容易

@制限事項
  - import順や内容によってはユーザープラグインと競合する場合があります。

@参考
  - https://github.com/AstroNvim/astrocommunity

]]

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- Language packs
  { import = "astrocommunity.pack.lua" },

  -- Colorschemes
  { import = "astrocommunity.colorscheme.catppuccin" },
  {
    "catppuccin",
    ---@type CatppuccinOptions
    opts = {
      transparent_background = true,
    },
  },
  { import = "astrocommunity.color.transparent-nvim" },

  -- Git integration
  { import = "astrocommunity.git.blame-nvim" },
  { import = "astrocommunity.git.diffview-nvim" },

  -- UI and navigation
  { import = "astrocommunity.scrolling.nvim-scrollbar" },
  { import = "astrocommunity.scrolling.neoscroll-nvim" },
  { import = "astrocommunity.search.nvim-hlslens" },
  { import = "astrocommunity.utility.noice-nvim" },

  -- Motion
  { import = "astrocommunity.motion.flash-nvim" },

  -- Editor enhancements
  { import = "astrocommunity.indent.mini-indentscope" },
  -- Language support
  { import = "astrocommunity.programming-language-support.csv-vim" },
}
