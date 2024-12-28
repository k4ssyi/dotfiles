-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/playground",
    "nvim-treesitter/nvim-treesitter-refactor",
  },
  opts = {
    ensure_installed = {
      -- add more arguments for adding more treesitter parsers
      "c",
      "lua",
      "luadoc",
      "git_config",
      "git_rebase",
      "gitcommit",
      "gitignore",
      "go",
      "html",
      "javascript",
      "json",
      "prisma",
      "python",
      "query",
      "sql",
      "toml",
      "tsv",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
  },
}
