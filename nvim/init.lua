--[[
init.lua - Neovim起動時のエントリーポイント

@概要
  - Lazy.nvimのインストール・初期化を行い、lazy_setup.luaやpolish.lua等の設定ファイルを呼び出します。
  - 基本的に編集不要ですが、必要に応じてカスタマイズ可能です。

@主な仕様
  - Lazy.nvimが未インストールの場合は自動でgit clone
  - lazy_setup.lua, polish.luaを順次require

@制限事項
  - 編集時は動作に注意してください（起動不能になる場合あり）

@参考
  - https://github.com/folke/lazy.nvim
  - https://github.com/AstroNvim/AstroNvim

]]

-- Git worktree検出（telescope.nvim用）
local function detect_git_worktrees()
  local handle = io.popen("git rev-parse --git-dir 2>/dev/null")
  if handle then
    local gitdir = handle:read("*a"):gsub("\n", "")
    handle:close()
    if gitdir and gitdir:match("worktrees") then
      local toplevel_handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
      if toplevel_handle then
        local toplevel = toplevel_handle:read("*a"):gsub("\n", "")
        toplevel_handle:close()
        if toplevel ~= "" and gitdir ~= "" then
          return { { toplevel = toplevel, gitdir = gitdir } }
        end
      end
    end
  end
  return nil
end
vim.g.git_worktrees = detect_git_worktrees()

local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- lazy.nvimのロード確認
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

require "lazy_setup"
require "polish"
