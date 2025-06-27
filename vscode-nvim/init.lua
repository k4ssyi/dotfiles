-- VSCode Neovim専用設定
if vim.g.vscode then
  -- VSCode Neovim設定ディレクトリの正確なパス
  local vscode_nvim_path = vim.fn.expand("~/.config/vscode-nvim")
  local current_file_dir = vim.fn.expand("%:p:h")
  
  -- package.pathにvscode-nvim/luaディレクトリを追加
  package.path = package.path .. ";" .. vscode_nvim_path .. "/lua/?.lua"
  package.path = package.path .. ";" .. current_file_dir .. "/lua/?.lua"
  
  -- 安全な設定読み込み
  local ok, err = pcall(require, "option")
  if not ok then
    vim.api.nvim_err_writeln("VSCode Neovim option loading failed: " .. err)
    vim.api.nvim_err_writeln("Searching in paths: " .. vscode_nvim_path .. "/lua/ and " .. current_file_dir .. "/lua/")
  end
  
  -- プラグイン読み込み（オプション）
  local plugin_ok, plugin_err = pcall(require, "plugins")
  if not plugin_ok then
    -- プラグインエラーは警告レベル（必須ではない）
    vim.notify("VSCode Neovim plugins not loaded: " .. plugin_err, vim.log.levels.WARN)
  end
else
  -- 通常のNeovim環境での警告
  vim.defer_fn(function()
    vim.notify(
      "Warning: This config is optimized for VSCode Neovim. Consider using AstroNvim for standalone usage.",
      vim.log.levels.WARN,
      { title = "VSCode Neovim Config" }
    )
  end, 100)
end
