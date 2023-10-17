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
        build =
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
    -- Syntax
    { "Mofiqul/dracula.nvim" },
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            vim.cmd("TSUpdate")
        end
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
    { "lukas-reineke/lsp-format.nvim" },
    { "onsails/lspkind.nvim" },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
    },
    -- Status line
    {
        'nvim-lualine/lualine.nvim',
        requires = {
            'nvim-tree/nvim-web-devicons',
            opt = true
        }
    },
    -- Git
    {
        "lewis6991/gitsigns.nvim",
    },
}

return plugins
