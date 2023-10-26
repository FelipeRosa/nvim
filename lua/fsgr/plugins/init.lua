local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local M = {}

M.load = function()
	local plugins = {
		{ "nvim-lua/plenary.nvim" },
	}

	vim.list_extend(plugins, require("fsgr.plugins.earthly"))
	vim.list_extend(plugins, require("fsgr.plugins.git"))
	vim.list_extend(plugins, require("fsgr.plugins.lsp"))
	vim.list_extend(plugins, require("fsgr.plugins.markdown"))
	vim.list_extend(plugins, require("fsgr.plugins.python"))
	vim.list_extend(plugins, require("fsgr.plugins.syntax"))
	vim.list_extend(plugins, require("fsgr.plugins.telescope"))
	vim.list_extend(plugins, require("fsgr.plugins.themes"))
	vim.list_extend(plugins, require("fsgr.plugins.ui"))

	require("lazy").setup(plugins)
end

return M
