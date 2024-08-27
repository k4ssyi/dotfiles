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
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
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
        ["<C-a>"] = { "^" },
        ["<C-e>"] = { "$" },

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
        ["gr"] = {
          function() require("telescope.builtin").lsp_references() end,
          desc = "Search References",
        },
        -- copilot chat mappings
        ["<leader>tc"] = { name = "CopilotChat" },
        ["<leader>tct"] = {
          function() require("CopilotChat").toggle { buffer = vim.api.nvim_get_current_buf() } end,
          desc = "CopilotChat - Toggle Open",
        },
        ["<leader>tcq"] = {
          function()
            local input = vim.fn.input "Quick Chat: "
            if input ~= "" then
              require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
            end
          end,
          desc = "CopilotChat - Quick chat",
        },

        ["<leader>tch"] = {
          function()
            local actions = require "CopilotChat.actions"
            require("CopilotChat.integrations.telescope").pick(actions.help_actions())
          end,
          desc = "CopilotChat - Help actions",
        },

        ["<leader>tcp"] = {
          function()
            local actions = require "CopilotChat.actions"
            require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
          end,
          desc = "CopilotChat - Prompt actions",
        },
      },
      -- insert mode
      i = {
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
  },
}
