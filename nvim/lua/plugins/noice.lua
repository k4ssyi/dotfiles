return {
  "folke/noice.nvim",
  config = function()
    require("noice").setup {
      lsp = {
        signature = {
          enabled = false,
        },
      },
    }
  end,
}
