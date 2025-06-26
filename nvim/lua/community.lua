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
  { import = "astrocommunity.pack.lua" },
  -- import/override with your plugins folder
  -- { import = "astrocommunity.colorscheme.everforest" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.color.transparent-nvim" },
  { import = "astrocommunity.scrolling.nvim-scrollbar" },
  { import = "astrocommunity.indent.mini-indentscope" },
  { import = "astrocommunity.programming-language-support.csv-vim" },
  { import = "astrocommunity.git.blame-nvim" },
}
