return {
  "folke/noice.nvim",
  config = function()
    require("noice").setup {
      lsp = {
        hover = {
          enabled = false,
          silent = false,
          view = nil,
          opts = {},
        },
        signature = {
          enabled = false,
        },
      },
    }
  end,
}
