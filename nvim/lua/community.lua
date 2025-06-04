-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  -- import/override with your plugins folder
  { import = "astrocommunity.colorscheme.everforest" },
  { import = "astrocommunity.color.transparent-nvim" },
  { import = "astrocommunity.scrolling.nvim-scrollbar" },
  { import = "astrocommunity.indent.mini-indentscope" },
  { import = "astrocommunity.programming-language-support.csv-vim" },
  { import = "astrocommunity.git.blame-nvim" },
}
