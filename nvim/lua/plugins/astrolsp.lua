-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing
local function remember_cursor_position()
  local pos = vim.api.nvim_win_get_cursor(0) -- 現在のカーソル位置を保存
  vim.lsp.buf.format({ timeout_ms = 1000 }) -- 1000msのタイムアウトでフォーマットを実行
  vim.api.nvim_win_set_cursor(0, pos) -- 保存した位置にカーソルを戻す
end

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
        "tsserver",
        "pylsp",
      },
      timeout_ms = 10000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      "vtsls",
      typos_lsp = {
        init_options = {
          config = vim.fn.filereadable(vim.fn.getcwd() .. "/typos.toml") == 1 and vim.fn.getcwd() .. "/typos.toml"
            or vim.fn.expand "~/.config/typos.toml",
        },
        cmd_env = { RUST_LOG = "debug" }, -- 必要に応じてデバッグログを有効にする
      },
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      vtsls = {
        cmd = { "vtsls", "--stdio" },
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
        settings = {
          vtsls = {
            experimental = {
              completion = {
                enableServerSideFuzzyMatch = true,
                entriesLimit = 10,
              },
            },
            autoUseWorkspaceTsdk = true,
          },
          typescript = {
            inlayHints = {
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
            tsserver = {
              maxTsServerMemory = 8192,
            },
          },
        },
      },
    },
    -- customize how language servers are attached
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` (:h augroup)
      lsp_document_highlight = {
        -- condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/documentHighlight",
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "CursorHold", "CursorHoldI" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Document Highlighting",
          callback = function() vim.lsp.buf.document_highlight() end,
        },
        {
          event = { "CursorMoved", "CursorMovedI", "BufLeave" },
          desc = "Document Highlighting Clear",
          callback = function() vim.lsp.buf.clear_references() end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
        gd = {
          function() require("telescope.builtin").lsp_definitions { reuse_win = true } end,
          desc = "Go to definition",
        },
        gI = {
          function() require("telescope.builtin").lsp_implementations { reuse_win = true } end,
          desc = "Go to implementation",
        },
        gy = {
          function() require("telescope.builtin").lsp_type_definitions { reuse_win = true } end,
          desc = "Go to type definition",
        },
        gr = {
          function() require("telescope.builtin").lsp_references() end,
          desc = "List references",
        },
        ["<Leader>lG"] = {
          function()
            vim.ui.input({ prompt = "Symbol Query: (leave empty for word under cursor)" }, function(query)
              if query then
                -- word under cursor if given query is empty
                if query == "" then query = vim.fn.expand "<cword>" end
                require("telescope.builtin").lsp_workspace_symbols {
                  query = query,
                  prompt_title = ("Find word (%s)"):format(query),
                }
              end
            end)
          end,
          desc = "Search workspace symbols",
        },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}
