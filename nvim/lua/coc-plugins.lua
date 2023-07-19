-- vim-jetpack(Packer.nvim v1 style)
vim.cmd('packadd vim-jetpack')
require('jetpack.packer').startup(function(use)

  use { 'tani/vim-jetpack' } -- bootstrap

  -- Common Plugin(Lua)
  use 'antoinemadec/FixCursorHold.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'folke/lsp-colors.nvim'

  -- colorscheme
  -- use 'Mofiqul/dracula.nvim'
  use 'navarasu/onedark.nvim'
  -- coc.nvim
  use {'neoclide/coc.nvim', branch = 'release', event = { "VimEnter" }}

  -- Statusline
  use 'nvim-lualine/lualine.nvim'

  -- Buffer Control
  -- use 'zefei/vim-wintabs'
  -- use 'zefei/vim-wintabs-powerline'
  use {'romgrk/barbar.nvim', requires = 'nvim-web-devicons'}

  -- Fern.vim
  -- use 'lambdalisue/nerdfont.vim'
  -- use 'lambdalisue/fern-renderer-nerdfont.vim' -- これでレンダリングするとアイコンのサイズが変？
  use 'lambdalisue/fern.vim'
  use 'lambdalisue/glyph-palette.vim'
  use 'TheLeoP/fern-renderer-web-devicons.nvim'

  use 'kyazdani42/nvim-web-devicons'

  --Syntax Highlight
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }

  use {'JoosepAlviste/nvim-ts-context-commentstring'} -- context-comment with treesitter
  use {'digitaltoad/vim-pug', event = { "VimEnter" }} -- for .jade,.pug file syntax

  -- Telescope
  use {'nvim-telescope/telescope.nvim' }
  use 'fannheyward/telescope-coc.nvim'
  use {
    "nvim-telescope/telescope-frecency.nvim",
    requires = {"kkharji/sqlite.lua"}
  }

  -- Coding Support
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'
  -- use 'haringsrob/nvim_context_vt'

  use {'petertriho/nvim-scrollbar'}
  use {
    "kevinhwang91/nvim-hlslens",
    config = function()
      -- require('hlslens').setup() is not required
      require("scrollbar.handlers.search").setup({
          -- hlslens config overrides
      })
    end,
  }

  use {'haya14busa/vim-asterisk',}
  use {'lukas-reineke/indent-blankline.nvim' }
  use {'numToStr/Comment.nvim' }
  use {'norcalli/nvim-colorizer.lua', }
  use {"kylechui/nvim-surround"}

  use {'simeji/winresizer' }

  use({
      "iamcco/markdown-preview.nvim",
      run = function() vim.fn["mkdp#util#install"]() end,
  })

  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })
  -- Rust Integration
  -- use 'rust-lang/rust.vim'

  -- For using Prettier
  use {'prettier/vim-prettier',event = { "VimEnter" }}

  -- Git Integration
  -- use 'dinhhuy258/git.nvim'
  use {'tpope/vim-fugitive' ,event = { "VimEnter" }}
  use 'lewis6991/gitsigns.nvim'
  -- use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }

  use 'github/copilot.vim'

  -- terminal Integration
  use { 'akinsho/toggleterm.nvim'}
end)

