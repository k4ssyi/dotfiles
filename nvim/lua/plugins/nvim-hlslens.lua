return {
  "kevinhwang91/nvim-hlslens",
  opts = {},
  event = "BufRead",
  init = function()
    vim.on_key(nil, vim.api.nvim_get_namespaces()["auto_hlsearch"])

    local kopts = { noremap = true, silent = true }

    vim.api.nvim_set_keymap(
      "n",
      "n",
      [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
      vim.tbl_extend("force", kopts, { desc = "Next search result with hlslens" })
    )
    vim.api.nvim_set_keymap(
      "n",
      "N",
      [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
      vim.tbl_extend("force", kopts, { desc = "Previous search result with hlslens" })
    )
    vim.api.nvim_set_keymap(
      "n",
      "*",
      [[*<Cmd>lua require('hlslens').start()<CR>]],
      vim.tbl_extend("force", kopts, { desc = "Search word under cursor with hlslens" })
    )
    vim.api.nvim_set_keymap(
      "n",
      "#",
      [[#<Cmd>lua require('hlslens').start()<CR>]],
      vim.tbl_extend("force", kopts, { desc = "Search word under cursor backwards with hlslens" })
    )
    vim.api.nvim_set_keymap(
      "n",
      "g*",
      [[g*<Cmd>lua require('hlslens').start()<CR>]],
      vim.tbl_extend("force", kopts, { desc = "Search partial word under cursor with hlslens" })
    )
    vim.api.nvim_set_keymap(
      "n",
      "g#",
      [[g#<Cmd>lua require('hlslens').start()<CR>]],
      vim.tbl_extend("force", kopts, { desc = "Search partial word under cursor backwards with hlslens" })
    )

    -- Add mapping to clear search highlight on double Esc
    vim.api.nvim_set_keymap(
      "n",
      "<Esc><Esc>",
      "<Cmd>nohlsearch<CR>",
      vim.tbl_extend("force", kopts, { desc = "Clear search highlight" })
    )
  end,
}
