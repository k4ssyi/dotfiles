-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvimtools/none-ls-extras.nvim",
  },
  opts = function(_, opts)
    -- opts variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"
    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

    -- Only insert new sources, do not replace the existing ones
    -- (If you wish to replace, use `opts.sources = {}` instead of the `list_insert_unique` function)
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- Set a formatter
      require("none-ls.formatting.jq").with {
        condition = function(utils) return utils.has_file { "biome.json", "biome.jsonc" } == false end,
      },
      require("none-ls.formatting.eslint_d").with {
        condition = function(utils) return utils.has_file { ".eslintrc.json", ".eslintrc.js", ".eslint.config.js" } end,
      },
      null_ls.builtins.formatting.prettierd.with {
        condition = function(utils) return utils.has_file { ".prettierrc", ".prettierrc.js" } end,
      },
      null_ls.builtins.formatting.biome.with {
        condition = function(utils) return utils.has_file { "biome.json", "biome.jsonc" } end,
      },
    })
  end,
}
