--[[
config/lsp/servers.lua - LSPサーバー設定

@概要
  - mason未使用サーバーの手動有効化設定

@戻り値
  - AstroLSPのservers設定に対応するテーブル

]]

return {
  "vtsls",
  typos_lsp = {
    init_options = {
      config = vim.fn.filereadable(vim.fn.getcwd() .. "/typos.toml") == 1 and vim.fn.getcwd() .. "/typos.toml"
        or vim.fn.expand "~/.config/typos.toml",
    },
    cmd_env = { RUST_LOG = "debug" }, -- 必要に応じてデバッグログを有効にする
  },
}