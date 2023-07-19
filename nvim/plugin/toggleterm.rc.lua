-- Toggleterm 

local status,term = pcall(require,"toggleterm")
if (not status) then return end

term.setup{
  direction =  'float',
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = 'single',
    -- like `size`, width and height can be a number or function which is passed the current terminal
    winblend = 0, -- ターミナルが透明のときは0にしないと正常に表示されない
  }
}

vim.keymap.set('n','<leader>t',':ToggleTerm<CR>',{silent = true,noremap = true})