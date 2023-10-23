require("Comment").setup()

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"gopls",
		"lua_ls",
		"pyright",
		"rust_analyzer",
	},
})

local telescope_builtin = require("telescope.builtin")
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local bufopts = { noremap = true, buffer = ev.buf }

		vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, bufopts)
		vim.keymap.set("n", "gt", telescope_builtin.lsp_type_definitions, bufopts)
		vim.keymap.set("n", "gi", telescope_builtin.lsp_implementations, bufopts)
		vim.keymap.set("n", "gr", telescope_builtin.lsp_references, bufopts)
		vim.keymap.set("n", "gt", telescope_builtin.lsp_type_definitions, bufopts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)

		vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, bufopts)
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, bufopts)
		vim.keymap.set("n", "<leader>ls", telescope_builtin.lsp_document_symbols, bufopts)
		vim.keymap.set("n", "<leader>lS", telescope_builtin.lsp_dynamic_workspace_symbols, bufopts)

		vim.keymap.set("n", "gl", vim.diagnostic.open_float, bufopts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
	end,
})

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Lua LS
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

-- Python LS
lspconfig.pyright.setup({
	capabilities = capabilities,
})
lspconfig.ruff_lsp.setup({
	capabilities = capabilities,
})

-- Go LS
lspconfig.gopls.setup({
	capabilities = capabilities,
	settings = {
		gopls = {
			gofumpt = true,
		},
	},
})

-- Rust LS
lspconfig.rust_analyzer.setup({
	on_attach = function(_, bufnr)
		local bufopts = { noremap = true, buffer = bufnr }

		local rust = require("fsgr.rust")
		vim.keymap.set("n", "<leader>rc", rust.open_cargo_toml, bufopts)
		vim.keymap.set("n", "<leader>rr", rust.reload_workspace, bufopts)
	end,
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {
			imports = {
				granularity = {
					group = "module",
				},
				prefix = "self",
			},
			check = {
				command = "clippy",
			},
			cargo = {
				buildScripts = {
					enable = true,
				},
			},
			procMacro = {
				enable = true,
			},
		},
	},
})

require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.WARN,
	filetype = {
		lua = require("formatter.filetypes.lua").stylua,
		python = {
			require("formatter.filetypes.python").black,
		},
		rust = {
			require("formatter.filetypes.rust").rustfmt,
		},
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})

local lsp_formatted = { "go" }

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
	callback = function(opts)
		local lsp_format = false
		for _, ft in ipairs(lsp_formatted) do
			if vim.bo[opts.buf].filetype == ft then
				lsp_format = true
				break
			end
		end

		if lsp_format then
			vim.lsp.buf.format()
		else
			vim.cmd(":FormatWrite")
		end

		-- Fix diagnostics going alway after formatting.
		vim.diagnostic.enable()
	end,
})

local cmp = require("cmp")
local lspkind = require("lspkind")
cmp.setup({
	completion = {
		autocomplete = false,
	},
	enabled = function()
		-- Disable when in comments
		local context = require("cmp.config.context")
		if vim.api.nvim_get_mode().mode == "c" then
			return true
		else
			return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
		end
	end,
	sources = {
		{
			name = "nvim_lsp",
			entry_filter = function(entry)
				return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
			end,
		},
		{ name = "path" },
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = {
		["<C-n>"] = cmp.mapping({
			i = function()
				if cmp.visible() then
					cmp.select_next_item({ behaviour = "insert" })
				else
					cmp.complete()
				end
			end,
		}),
		["<C-p>"] = cmp.mapping({
			i = function()
				if cmp.visible() then
					cmp.select_prev_item({ behaviour = "insert" })
				else
					cmp.complete()
				end
			end,
		}),
		["<CR>"] = cmp.mapping({
			i = function(fallback)
				if cmp.visible() and cmp.get_active_entry() then
					cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
				else
					fallback()
				end
			end,
			s = cmp.mapping.confirm({ select = true }),
			c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
		}),
		["<C-e>"] = cmp.mapping({
			i = function(fallback)
				if cmp.visible() then
					cmp.abort()
				else
					fallback()
				end
			end,
		}),
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	formatting = {
		format = lspkind.cmp_format({
			-- show only symbol annotations
			mode = "symbol",
			-- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			maxwidth = 50,
			-- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
			ellipsis_char = "...",
			-- The function below will be called before any actual modifications from lspkind
			-- so that you can provide more controls on popup customization.
			-- See [#30](https://github.com/onsails/lspkind-nvim/pull/30)
			before = function(_, vim_item)
				return vim_item
			end,
		}),
	},
	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.sort_text,
			cmp.config.compare.kind,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
})
