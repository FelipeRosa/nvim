local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })

    if client.supports_method("textDocument/formatting") then
        require("lsp-format").on_attach(client)
    end
end)

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "gopls",
        "lua_ls",
        "pyright",
        "rust_analyzer",
    },
    handlers = {
        lsp.default_setup,
    },
})


local cmp = require("cmp")
local lspkind = require("lspkind")
cmp.setup({
    sources = {
        {
            name = "nvim_lsp",
            entry_filter = function(entry)
                return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
            end
        },
        { name = "path" },
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ["<Down>"] = cmp.mapping.select_next_item({ behaviour = "select" }),
        ["<Up>"] = cmp.mapping.select_prev_item({ behaviour = "select" }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Esc>"] = cmp.mapping.abort(),
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol',       -- show only symbol annotations
            maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(_entry, vim_item)
                return vim_item
            end
        })
    },
})

require("lsp_signature").setup()

lsp.setup()
