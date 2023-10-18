local plugins = {
	-- Telescope
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
	-- Syntax
	{ "Mofiqul/dracula.nvim" },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},
	{
		"nvim-treesitter/nvim-treesitter",
	},
	-- LSP
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/nvim-cmp" },
			{ "L3MON4D3/LuaSnip" },
		},
	},
	{ "mhartington/formatter.nvim" },
	{ "mfussenegger/nvim-lint" },
	{ "onsails/lspkind.nvim" },
	{
		"numToStr/Comment.nvim",
		lazy = false,
	},
	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		requires = {
			"nvim-tree/nvim-web-devicons",
			opt = true,
		},
	},
	-- Git
	{ "lewis6991/gitsigns.nvim" },
	{ "sindrets/diffview.nvim" },
	-- Python
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
		event = "VeryLazy",
	},
	-- Icons
	{ "nvim-tree/nvim-web-devicons" },
}

return plugins
