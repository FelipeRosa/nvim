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
cmp.setup({
    sources = {
        { name = "nvim_lsp" },
    },
    mapping = {
        ["<Down>"] = cmp.mapping.select_next_item({ behaviour = "select" }),
        ["<Up>"] = cmp.mapping.select_prev_item({ behaviour = "select" }),
        ["<Enter>"] = cmp.mapping.confirm({ select = false }),
        ["<Esc>"] = cmp.mapping.abort(),
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})

lsp.setup()
