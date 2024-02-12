if vim.g.vscode then
	package.path = package.path .. ';/Users/k4ssyi/.config/vscode-nvim/lua/?.lua'
	-- VSCode extension
	-- require("plugins") -- プラグイン管理
	require('option') -- シンタックスハイライトやインデントなどの各種設定
	require('keymaps') -- キーマップ(キーバインド)の設定
else
	-- ordinary Neovim
	-- errorメッセージを表示する
	vim.notify = function(msg, log_level, _opts)
		if log_level == vim.log.levels.ERROR then
			vim.api.nvim_err_writeln(msg)
		else
			vim.api.nvim_echo({ { msg } }, true, {})
		end
	end
	vim.notify("I should be using AstroNvim, so this shouldn't be displayed.", vim.log.levels.INFO)
end
