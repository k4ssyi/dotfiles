--vim-fugitiveとNeogitを併用

vim.cmd([[
nnoremap <silent> <space>s :Git<CR><C-w>T
nnoremap <silent> <space>b :Git blame<CR>
nnoremap <silent> <space>d :Gvdiffsplit<CR>
nnoremap <silent> <space>w :Gwrite<CR>
]])
-- nnoremap <silent> <space>l :Git log --graph<CR><C-w>T

-- neogit
-- local neogit = require('neogit')

-- neogit.setup {}