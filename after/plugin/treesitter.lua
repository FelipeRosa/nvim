-- Add templ parser manually
local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
treesitter_parser_config.templ = {
	install_info = {
		url = "https://github.com/vrischmann/tree-sitter-templ.git",
		files = { "src/parser.c", "src/scanner.c" },
		branch = "master",
	},
}
vim.treesitter.language.register("templ", "templ")

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"fish",
		"go",
		"gomod",
		"html",
		"lua",
		"vim",
		"vimdoc",
		"python",
		"query",
		"rust",
		"templ",
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
