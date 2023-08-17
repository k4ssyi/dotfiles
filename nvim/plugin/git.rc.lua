vim.keymap.set('n', 'gs', ':Git<CR><C-w>T', { silent = true })
vim.keymap.set('n', 'gb', ':Git blame<CR>', { silent = true })
vim.keymap.set('n', 'gd', ':Gvdiffsplit<CR>', { silent = true })
vim.keymap.set('n', 'gw', ':Gwrite<CR>', { silent = true })
vim.keymap.set('n', 'gl', ':Git log --graph<CR><C-w>T', { silent = true })

-- neogit
-- local neogit = require('neogit')

-- neogit.setup {}

