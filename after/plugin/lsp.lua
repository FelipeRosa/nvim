require("Comment").setup()

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"gopls",
		"pyright",
		"rust_analyzer",
		-- Unable to do this because npm is trying ipv6 by default
		-- and, for some reason, it gets stuck.
		-- "tsserver",
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

local lsp_signature = require("lsp_signature")
lsp_signature.setup({})
lsp_signature_cfg = { bind = true }

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lsp_configs = {
	pyright = {
		capabilities = capabilities,
	},
	ruff_lsp = {
		capabilities = capabilities,
	},
	gopls = {
		on_attach = function(_, bufnr)
			local bufopts = { noremap = true, buffer = bufnr }

			local lsp_restart = function()
				vim.cmd("LspRestart")
			end

			vim.keymap.set("n", "<leader>rr", lsp_restart, bufopts)
		end,
		capabilities = capabilities,
		settings = {
			gopls = {
				gofumpt = true,
			},
		},
	},
	rust_analyzer = {
		on_attach = function(_, bufnr)
			local bufopts = { noremap = true, buffer = bufnr }

			local rust = require("fsgr.rust")
			vim.keymap.set("n", "<leader>rc", rust.open_cargo_toml, bufopts)
			vim.keymap.set("n", "<leader>rr", rust.reload_workspace, bufopts)

			lsp_signature.on_attach(lsp_signature_cfg, bufnr)
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
				checkOnSave = {
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
	},
	tsserver = {
		capabilities = capabilities,
	},
}

for lspname, opts in pairs(lsp_configs) do
	lspconfig[lspname].setup(opts)
end

local formatters_by_ft = {
	lua = require("formatter.filetypes.lua").stylua,
	python = {
		require("formatter.filetypes.python").black,
	},
	markdown = {
		require("formatter.filetypes.markdown").prettier,
	},
	["*"] = {
		require("formatter.filetypes.any").remove_trailing_whitespace,
	},
}

require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.WARN,
	filetype = formatters_by_ft,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
	callback = function(opts)
		local filetype = vim.bo[opts.buf].filetype

		local lsp_format = true
		for ft, _ in pairs(formatters_by_ft) do
			if filetype == ft then
				lsp_format = false
				break
			end
		end

		if lsp_format and #vim.lsp.buf_get_clients() > 0 then
			vim.lsp.buf.format()
		else
			vim.cmd(":FormatWrite")
		end
	end,
})

local cmp = require("cmp")
local lspkind = require("lspkind")
cmp.setup({
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
		-- Taken from https://github.com/hrsh7th/nvim-cmp/discussions/609
		format = function(entry, item)
			-- Define menu shorthand for different completion sources.
			local menu_icon = {
				nvim_lsp = "NLSP",
				nvim_lua = "NLUA",
				luasnip = "LSNP",
				buffer = "BUFF",
				path = "PATH",
			}
			-- Set the menu "icon" to the shorthand for each completion source.
			item.menu = menu_icon[entry.source.name]

			-- Set the fixed width of the completion menu to 60 characters.
			-- fixed_width = 20

			-- Set 'fixed_width' to false if not provided.
			fixed_width = fixed_width or false

			-- Get the completion entry text shown in the completion window.
			local content = item.abbr

			-- Set the fixed completion window width.
			if fixed_width then
				vim.o.pumwidth = fixed_width
			end

			-- Get the width of the current window.
			local win_width = vim.api.nvim_win_get_width(0)

			-- Set the max content width based on either: 'fixed_width'
			-- or a percentage of the window width, in this case 20%.
			-- We subtract 10 from 'fixed_width' to leave room for 'kind' fields.
			local max_content_width = fixed_width and fixed_width - 10 or math.floor(win_width * 0.2)

			-- Truncate the completion entry text if it's longer than the
			-- max content width. We subtract 3 from the max content width
			-- to account for the "..." that will be appended to it.
			if #content > max_content_width then
				item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
			else
				item.abbr = content .. (" "):rep(max_content_width - #content)
			end
			return item
		end,
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
