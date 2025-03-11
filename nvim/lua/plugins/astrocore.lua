-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 1024, lines = 10000 },
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- easily configure auto commands
    autocmds = {
      -- first key is the `augroup` (:h augroup)
      highlighturl = {
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "VimEnter", "FileType", "BufEnter", "WinEnter" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "URL Highlighting",
          callback = function() require("astrocore").set_url_match() end,
        },
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        swapfile = false, -- sets vim.opt.swapfile to false
        wrap = true, -- sets vim.opt.wrap to false
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- 行の端に行く
        ["<C-a>"] = { "^", noremap = true },
        ["<C-e>"] = { "$", noremap = true, silent = true, desc = "Move to end of line" },

        -- split window resize
        -- Alt key
        ["∆"] = { ":resize +2<CR>", desc = "Resize split up" },
        ["˚"] = { ":resize -2<CR>", desc = "Resize split down" },
        ["¬"] = { ":vertical resize +2<CR>", desc = "Resize split left" },
        ["˙"] = { ":vertical resize -2<CR>", desc = "Resize split right" },

        -- Do not yank with x
        x = { '"_x', desc = "do not yank with x" },

        -- second key is the lefthand side of the map
        ["\\"] = { "<cmd>vsplit<cr>", desc = "Vertical Split" },
        ["-"] = { "<cmd>split<cr>", desc = "Horizontal Split" },

        -- navigate buffer tabs
        ["L"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["H"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
        -- plugin mappings
        ["<leader>gnd"] = { "<cmd>DiffviewOpen<cr>", desc = "View Git diffviewOpen" },
      },
      -- insert mode
      i = {
        ["jj"] = { "<Esc>", desc = "Escape insert mode", silent = true, noremap = true },
        ["ｊｊ"] = { "<Esc>", desc = "Escape insert mode", silent = true, noremap = true },
        -- カーソルを行の末尾に移動
        ["<C-e>"] = { "<Esc>A", desc = "Move to end of line" },
        -- カーソルを行の先頭に移動
        ["<C-a>"] = { "<Esc>I", desc = "Move to start of line" },
      },
      -- visual mode
      v = {
        x = { '"_x', desc = "do not yank with x" },
        ["<C-a>"] = { "^" },
        ["<C-e>"] = { "$" },
      },
    },
    -- easily configure functions on key press
    on_keys = {
      -- first key is the namespace
      auto_hlsearch = {
        -- list of functions to execute on key press (:h vim.on_key)
        function(char) -- example automatically disables `hlsearch` when not actively searching
          if vim.fn.mode() == "n" then
            local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
            if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
          end
        end,
      },
    },
    -- Configure project root detection, check status with `:AstroRootInfo`
    rooter = {
      -- list of detectors in order of prevalence, elements can be:
      --   "lsp" : lsp detection
      --   string[] : a list of directory patterns to look for
      --   fun(bufnr: integer): string|string[] : a function that takes a buffer number and outputs detected roots
      detector = {
        "lsp", -- highest priority is getting workspace from running language servers
        { ".git", "_darcs", ".hg", ".bzr", ".svn" }, -- next check for a version controlled parent directory
        { "lua", "MakeFile", "package.json" }, -- lastly check for known project root files
      },
      -- ignore things from root detection
      ignore = {
        servers = {}, -- list of language server names to ignore (Ex. { "efm" })
        dirs = {}, -- list of directory patterns (Ex. { "~/.cargo/*" })
      },
      -- automatically update working directory (update manually with `:AstroRoot`)
      autochdir = false,
      -- scope of working directory to change ("global"|"tab"|"win")
      scope = "global",
      -- show notification on every working directory change
      notify = false,
    },
    -- Configuration table of session options for AstroNvim's session management powered by Resession
    sessions = {
      -- Configure auto saving
      autosave = {
        last = true, -- auto save last session
        cwd = true, -- auto save session for each working directory
      },
      -- Patterns to ignore when saving sessions
      ignore = {
        dirs = {}, -- working directories to ignore sessions in
        filetypes = { "gitcommit", "gitrebase" }, -- filetypes to ignore sessions
        buftypes = {}, -- buffer types to ignore sessions
      },
    },
  },
}
