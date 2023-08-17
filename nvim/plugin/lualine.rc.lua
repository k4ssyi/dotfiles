local status,lualine = pcall(require, "lualine")
if (not status) then return end

-- vim.cmd("colorscheme nordfox")

require('lualine').setup {
  options ={
    -- theme = "dracula-nvim"
    theme = "onedark"
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {
      'filetype',
      {
        'filename',
        path=1
      },
    },
    lualine_x = {'encoding', 'fileformat'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
