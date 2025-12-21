return {
  "monkoose/neocodeium",
  event = "VeryLazy",
  config = function()
    local neocodeium = require "neocodeium"
    neocodeium.setup()
    vim.keymap.set("i", "<A-Right>", function() neocodeium.cycle(1) end, { desc = "Next suggestion" })
    vim.keymap.set("i", "<A-Left>", function() neocodeium.cycle(-1) end, { desc = "Previous suggestion" })
    vim.keymap.set("i", "<Right>", function()
      if neocodeium.visible() then
        neocodeium.accept()
        return
      end
      local term = vim.api.nvim_replace_termcodes("<Right>", true, false, true)
      vim.api.nvim_feedkeys(term, "n", false)
    end, { desc = "Accept neocodeium suggestion" })
  end,
}
