--[[
config/lsp/handlers.lua - LSPサーバーのカスタムセットアップハンドラー

@概要
  - Biome/ESLint/Prettierの排他制御を管理
  - Biome設定があればBiomeを優先、なければESLint/Prettierにフォールバック

@戻り値
  - AstroLSPのhandlers設定に対応するテーブル

]]

--- プロジェクトルートに指定ファイルが存在するか判定
---@param files string[]
---@return boolean
local function has_config(files)
  local cwd = vim.fn.getcwd()
  for _, file in ipairs(files) do
    if vim.fn.filereadable(cwd .. "/" .. file) == 1 then return true end
  end
  return false
end

local biome_configs = { "biome.json", "biome.jsonc" }

local eslint_configs = {
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.mjs",
  ".eslintrc.json",
  ".eslintrc.yaml",
  ".eslintrc.yml",
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
}

return {
  -- Biome: biome.json/biome.jsonc がある場合のみ有効化
  biome = function(_, opts)
    if has_config(biome_configs) then
      -- node_modules/.bin/biome を優先、なければグローバルにフォールバック
      local local_biome = vim.fn.getcwd() .. "/node_modules/.bin/biome"
      if vim.fn.executable(local_biome) == 1 then opts.cmd = { local_biome, "lsp-proxy" } end
      ---@diagnostic disable-next-line: param-type-mismatch
      require("lspconfig").biome.setup(opts)
    end
  end,

  -- ESLint: Biomeがなく、ESLint設定ファイルがある場合のみ有効化
  eslint = function(_, opts)
    if has_config(biome_configs) then return end
    if has_config(eslint_configs) then
      ---@diagnostic disable-next-line: param-type-mismatch
      require("lspconfig").eslint.setup(opts)
    end
  end,
}
