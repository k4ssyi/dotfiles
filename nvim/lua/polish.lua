-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- mise環境の設定（Node.js、npmなどのパスを追加）
-- Neovim起動時にmiseで管理されているツールをPATHに追加
local function setup_mise_environment()
  -- miseのbinディレクトリをPATHに追加
  local mise_bin_dir = vim.fn.expand("~/.local/share/mise/bin")
  if vim.fn.isdirectory(mise_bin_dir) == 1 then
    local current_path = vim.env.PATH or ""
    if not current_path:match(mise_bin_dir) then
      vim.env.PATH = mise_bin_dir .. ":" .. current_path
    end
  end
  
  -- miseでインストールされたNode.jsのbinディレクトリをPATHに追加
  local node_bin_dir = vim.fn.expand("~/.local/share/mise/installs/node/20.11.0/bin")
  if vim.fn.isdirectory(node_bin_dir) == 1 then
    local current_path = vim.env.PATH or ""
    if not current_path:match(node_bin_dir) then
      vim.env.PATH = node_bin_dir .. ":" .. current_path
    end
  end
  
  -- より柔軟な方法: mise envコマンドを使用して環境変数を取得
  local mise_cmd = vim.fn.exepath("mise") or vim.fn.expand("~/.local/share/mise/bin/mise")
  if vim.fn.executable(mise_cmd) == 1 then
    -- mise envコマンドで環境変数を取得
    local handle = io.popen(mise_cmd .. " env -s sh 2>/dev/null")
    if handle then
      local result = handle:read("*a")
      handle:close()
      
      -- 環境変数を解析して設定
      for line in result:gmatch("[^\r\n]+") do
        -- export PATH="..." の形式を解析
        local path_match = line:match("export PATH=\"([^\"]+)\"")
        if path_match then
          -- PATHを更新（miseのパスを先頭に追加）
          local current_path = vim.env.PATH or ""
          -- 重複を避けるため、既に含まれているかチェック
          if not current_path:match(path_match:gsub("%-", "%%-")) then
            vim.env.PATH = path_match .. ":" .. current_path
          end
        end
      end
    end
  end
end

-- Neovim起動時にmise環境を設定
setup_mise_environment()

-- Set up custom filetypes
-- vim.filetype.add {
--   extension = {
--     foo = "fooscript",
--   },
--   filename = {
--     ["Foofile"] = "fooscript",
--   },
--   pattern = {
--     ["~/%.config/foo/.*"] = "fooscript",
--   },
-- }
