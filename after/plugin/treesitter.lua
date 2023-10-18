require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"go",
		"lua",
		"vim",
		"vimdoc",
		"python",
		"query",
		"rust",
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

vim.cmd("TSUpdate")
