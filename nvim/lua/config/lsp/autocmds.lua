--[[
config/lsp/autocmds.lua - LSP自動コマンド設定

@概要
  - LSPアタッチ時のバッファローカル自動コマンド設定

@戻り値
  - AstroLSPのautocmds設定に対応するテーブル

]]

-- Biome LSP で保存時に import 整理（並び替え・未使用削除）と format を自動実行
-- 参考: https://zenn.dev/izumin/articles/b8046e64eaa2b5

local M = {}

M.lsp_document_highlight = {
  cond = "textDocument/documentHighlight",
  {
    event = { "CursorHold", "CursorHoldI" },
    desc = "Document Highlighting",
    callback = function() vim.lsp.buf.document_highlight() end,
  },
  {
    event = { "CursorMoved", "CursorMovedI", "BufLeave" },
    desc = "Document Highlighting Clear",
    callback = function() vim.lsp.buf.clear_references() end,
  },
}

local function code_action_sync(client, bufnr, action)
  -- BufWritePre ではカーソル位置が不正な場合があるため、バッファ全体を範囲指定
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(bufnr),
    range = {
      start = { line = 0, character = 0 },
      ["end"] = { line = vim.api.nvim_buf_line_count(bufnr), character = 0 },
    },
    context = { only = { action }, diagnostics = {} },
  }
  local res = client.request_sync("textDocument/codeAction", params, 3000, bufnr)
  for _, r in pairs(res and res.result or {}) do
    if r.edit then
      local enc = (vim.lsp.get_client_by_id(client.id) or {}).offset_encoding or "utf-16"
      vim.lsp.util.apply_workspace_edit(r.edit, enc)
    end
  end
end

local function organize_imports_sync(client, bufnr) code_action_sync(client, bufnr, "source.organizeImports") end

local function fix_all_sync(client, bufnr) code_action_sync(client, bufnr, "source.fixAll") end

local function format_sync(client, bufnr)
  if client.supports_method "textDocument/formatting" then vim.lsp.buf.format { bufnr = bufnr, timeout_ms = 3000 } end
end

-- LSPごとに実行したい処理を定義
local lsp_actions = {
  biome = function(client, bufnr)
    fix_all_sync(client, bufnr)
    organize_imports_sync(client, bufnr)
    format_sync(client, bufnr)
  end,
  yamlls = function(client, bufnr) format_sync(client, bufnr) end,
  vtsls = function(client, bufnr)
    organize_imports_sync(client, bufnr)
    format_sync(client, bufnr)
  end,
  lua_ls = function(client, bufnr) format_sync(client, bufnr) end,
  eslint = function(client, bufnr) fix_all_sync(client, bufnr) end,
}

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("LspAutoActions", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    for _, client in pairs(vim.lsp.get_clients { bufnr = bufnr }) do
      local action = lsp_actions[client.name]
      if action then
        action(client, bufnr)
      end
    end
  end,
})

return M
