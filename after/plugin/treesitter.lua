require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"fish",
		"go",
		"gomod",
		"html",
		"javascript",
		"lua",
		"markdown",
		"vim",
		"vimdoc",
		"python",
		"query",
		"rust",
		"typescript",
	},
	ignore_install = {},
	modules = {},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

vim.cmd("TSUpdate")

require("treesitter-context").setup({
	enable = true,
	line_numbers = true,
	max_lines = 1,
})
