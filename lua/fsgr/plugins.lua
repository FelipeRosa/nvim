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

M._plugins = {
	git = {
		{ "lewis6991/gitsigns.nvim" },
		{ "sindrets/diffview.nvim" },
		{ "tpope/vim-fugitive" },
	},
	lsp = {
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "neovim/nvim-lspconfig" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/nvim-cmp" },
		{ "L3MON4D3/LuaSnip" },
		{ "mhartington/formatter.nvim" },
		{
			"folke/trouble.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
		{ "onsails/lspkind.nvim" },
		{ "numToStr/Comment.nvim", lazy = false },
	},
	languages = {
		-- Earthly
		{ "earthly/earthly.vim", branch = "main" },
		-- Python
		{
			"linux-cultist/venv-selector.nvim",
			dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
			event = "VeryLazy",
		},
		-- Rust
		{ "vxpm/ferris.nvim" },
	},
	syntax = {
		{ "nvim-treesitter/nvim-treesitter" },
		{ "nvim-treesitter/nvim-treesitter-context" },
	},
	telescope = {
		{
			"nvim-telescope/telescope.nvim",
			version = "0.1.4",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
		},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		},
	},
	themes = {
		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
		},
	},
	ui = {
		{ "nvim-tree/nvim-tree.lua" },
		{
			"nvim-lualine/lualine.nvim",
			requires = {
				"nvim-tree/nvim-web-devicons",
				opt = true,
			},
		},
		{ "nvim-tree/nvim-web-devicons" },
		{ "stevearc/dressing.nvim" },
		{
			"j-hui/fidget.nvim",
			tag = "legacy",
			event = "LspAttach",
		},
	},
}

M.load = function()
	local plugins = {
		{ "nvim-lua/plenary.nvim" },
	}

	for k in pairs(M._plugins) do
		vim.list_extend(plugins, M._plugins[k])
	end

	require("lazy").setup(plugins)
end

return M
