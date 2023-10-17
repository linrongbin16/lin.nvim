-- ---- Plugins ----

local lua_keys = require("builtin.utils.plugin").lua_keys
local lua_init = require("builtin.utils.plugin").lua_init
local lua_config = require("builtin.utils.plugin").lua_config
local vim_init = require("builtin.utils.plugin").vim_init
local vim_config = require("builtin.utils.plugin").vim_config

local VeryLazy = "VeryLazy"
local BufNewFile = "BufNewFile"
local BufReadPre = "BufReadPre"
local CmdlineEnter = "CmdlineEnter"
local VimEnter = "VimEnter"
local InsertEnter = "InsertEnter"
local UIEnter = "UIEnter"

local M = {
    -- ---- INFRASTRUCTURE ----

    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },
    {
        "folke/lsp-colors.nvim",
    },
    {
        "b0o/SchemaStore.nvim",
        lazy = true,
    },
    {
        "folke/neodev.nvim",
        lazy = true,
    },
    {
        "folke/neoconf.nvim",
        dependencies = { "b0o/SchemaStore.nvim", "folke/neodev.nvim" },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "folke/neoconf.nvim" },
        config = lua_config("neovim/nvim-lspconfig"),
    },

    -- ---- HIGHLIGHT ----

    {
        "nvim-treesitter/nvim-treesitter",
        event = { VeryLazy, BufReadPre, BufNewFile, CmdlineEnter },
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        config = lua_config("nvim-treesitter/nvim-treesitter"),
    },
    {
        "RRethy/vim-illuminate",
        event = { VeryLazy, BufReadPre, BufNewFile },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = lua_config("RRethy/vim-illuminate"),
    },
    {
        "NvChad/nvim-colorizer.lua",
        event = { VeryLazy, BufReadPre, BufNewFile },
        config = lua_config("NvChad/nvim-colorizer.lua"),
    },
    {
        "andymass/vim-matchup",
        event = { VeryLazy, BufReadPre, BufNewFile },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        init = lua_init("andymass/vim-matchup"),
    },
    {
        "inkarkat/vim-ingo-library",
        lazy = true,
    },
    {
        "inkarkat/vim-mark",
        event = { CmdlineEnter },
        dependencies = { "inkarkat/vim-ingo-library" },
        init = lua_init("inkarkat/vim-mark"),
        keys = lua_keys("inkarkat/vim-mark"),
    },
    {
        "markonm/traces.vim",
        event = { CmdlineEnter },
    },

    -- ---- UI ----

    {
        "MunifTanjim/nui.nvim",
        lazy = true,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        event = { UIEnter },
        dependencies = { "MunifTanjim/nui.nvim" },
        branch = "v3.x",
        config = lua_config("nvim-neo-tree/neo-tree.nvim"),
        keys = lua_keys("nvim-neo-tree/neo-tree.nvim"),
    },
    -- Tabline
    {
        "moll/vim-bbye",
        cmd = { "Bdelete", "Bwipeout" },
        keys = lua_keys("moll/vim-bbye"),
    },
    {
        "akinsho/bufferline.nvim",
        version = "v3.*",
        event = { UIEnter },
        dependencies = { "moll/vim-bbye" },
        config = lua_config("akinsho/bufferline.nvim"),
        keys = lua_keys("akinsho/bufferline.nvim"),
    },
    -- Indentline
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { VeryLazy, BufReadPre, BufNewFile },
        config = lua_config("lukas-reineke/indent-blankline.nvim"),
    },
    -- {
    --     "shellRaining/hlchunk.nvim",
    --     event = { VeryLazy, BufReadPre, BufNewFile },
    --     config = lua_config("shellRaining/hlchunk.nvim"),
    -- },
    -- Statusline
    {
        "linrongbin16/lsp-progress.nvim",
        lazy = true,
        event = { UIEnter },
        config = lua_config("linrongbin16/lsp-progress.nvim"),
    },
    {
        "nvim-lualine/lualine.nvim",
        event = { UIEnter },
        dependencies = { "linrongbin16/lsp-progress.nvim" },
        config = lua_config("nvim-lualine/lualine.nvim"),
    },
    -- Winbar
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        init = lua_init("SmiteshP/nvim-navic"),
    },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        event = { VeryLazy, BufReadPre, BufNewFile },
        dependencies = { "SmiteshP/nvim-navic" },
        config = lua_config("utilyre/barbecue.nvim"),
    },
    -- Git
    {
        "airblade/vim-gitgutter",
        event = { VeryLazy, BufReadPre, BufNewFile },
        init = lua_init("airblade/vim-gitgutter"),
        keys = lua_keys("airblade/vim-gitgutter"),
    },
    -- UI improvement
    {
        "stevearc/dressing.nvim",
        event = { UIEnter },
        dependencies = { "junegunn/fzf" },
        config = lua_config("stevearc/dressing.nvim"),
    },

    -- ---- SEARCH ----

    {
        "junegunn/fzf",
        event = { CmdlineEnter },
        build = ":call fzf#install()",
    },
    {
        "linrongbin16/fzfx.nvim",
        event = { CmdlineEnter },
        cmd = {
            "FzfxLspDefinitions",
            "FzfxLspTypeDefinitions",
            "FzfxLspReferences",
            "FzfxLspImplementations",
        },
        dependencies = { "junegunn/fzf" },
        config = lua_config("linrongbin16/fzfx.nvim"),
        keys = lua_keys("linrongbin16/fzfx.nvim"),
    },

    -- ---- LSP ----
    -- Lsp server management
    {
        "williamboman/mason.nvim",
        event = { VeryLazy, BufReadPre, BufNewFile, CmdlineEnter },
        build = ":MasonUpdate",
        config = lua_config("williamboman/mason.nvim"),
        keys = lua_keys("williamboman/mason.nvim"),
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = { VeryLazy, BufReadPre, BufNewFile, CmdlineEnter },
        dependencies = { "williamboman/mason.nvim" },
        config = lua_config("williamboman/mason-lspconfig.nvim"),
    },
    {
        "stevearc/conform.nvim",
        event = { VeryLazy, BufReadPre, BufNewFile, CmdlineEnter },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = lua_config("stevearc/conform.nvim"),
        keys = lua_keys("stevearc/conform.nvim"),
    },
    -- {
    --     "mfussenegger/nvim-lint",
    --     event = { VeryLazy, BufReadPre, BufNewFile, CmdlineEnter },
    --     dependencies = {
    --         "williamboman/mason.nvim",
    --         "williamboman/mason-lspconfig.nvim",
    --     },
    --     config = lua_config("mfussenegger/nvim-lint"),
    -- },
    {
        "nvimtools/none-ls.nvim",
        event = { VeryLazy, BufReadPre, BufNewFile, CmdlineEnter },
        config = lua_config("jose-elias-alvarez/null-ls.nvim"),
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = { VeryLazy, BufReadPre, BufNewFile, CmdlineEnter },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "nvimtools/none-ls.nvim",
        },
        config = lua_config("jay-babu/mason-null-ls.nvim"),
    },

    -- Auto-complete engine
    {
        "onsails/lspkind.nvim",
        lazy = true,
    },
    {
        "hrsh7th/cmp-nvim-lsp",
        event = { VeryLazy, InsertEnter },
    },
    {
        "hrsh7th/cmp-buffer",
        event = { VeryLazy, InsertEnter },
    },
    {
        "FelipeLema/cmp-async-path",
        event = { VeryLazy, InsertEnter, CmdlineEnter },
    },
    {
        "L3MON4D3/LuaSnip",
        event = { VeryLazy, InsertEnter },
        version = "v2.*",
        submodules = false,
    },
    {
        "saadparwaiz1/cmp_luasnip",
        event = { VeryLazy, InsertEnter },
        dependencies = { "L3MON4D3/LuaSnip" },
    },
    {
        "hrsh7th/cmp-cmdline",
        event = { VeryLazy, CmdlineEnter },
    },
    {
        "hrsh7th/nvim-cmp",
        event = { VeryLazy, InsertEnter, CmdlineEnter },
        dependencies = {
            "onsails/lspkind.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "FelipeLema/cmp-async-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-cmdline",
        },
        config = lua_config("hrsh7th/nvim-cmp"),
    },
    -- Symbol navigation
    {
        "DNLHC/glance.nvim",
        cmd = { "Glance" },
        config = lua_config("DNLHC/glance.nvim"),
    },
    -- Diagnostic
    {
        "folke/trouble.nvim",
        cmd = { "Trouble", "TroubleClose", "TroubleToggle", "TroubleRefresh" },
        config = lua_config("folke/trouble.nvim"),
        keys = lua_keys("folke/trouble.nvim"),
    },

    -- ---- SPECIFIC LANGUAGE SUPPORT ----

    -- Markdown
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install && git checkout .",
        ft = { "markdown" },
        init = lua_init("iamcco/markdown-preview.nvim"),
        keys = lua_keys("iamcco/markdown-preview.nvim"),
    },

    -- ---- KEY BINDING ----

    -- Key mappings
    {
        "folke/which-key.nvim",
        cmd = { "WhichKey" },
        config = lua_config("folke/which-key.nvim"),
        keys = lua_keys("folke/which-key.nvim"),
    },

    -- ---- GIT INTEGRATION ----

    -- Lazygit
    {
        "kdheepak/lazygit.nvim",
        init = lua_init("kdheepak/lazygit.nvim"),
        keys = lua_keys("kdheepak/lazygit.nvim"),
    },
    -- Blame
    {
        "f-person/git-blame.nvim",
        event = { VeryLazy, CmdlineEnter },
        init = lua_init("f-person/git-blame.nvim"),
        keys = lua_keys("f-person/git-blame.nvim"),
    },
    -- Permlink
    {
        "linrongbin16/gitlinker.nvim",
        lazy = true,
        config = lua_config("linrongbin16/gitlinker.nvim"),
        keys = lua_keys("linrongbin16/gitlinker.nvim"),
    },

    -- ---- ENHANCEMENT ----

    -- Auto pair/close
    {
        "windwp/nvim-autopairs",
        event = { VeryLazy, InsertEnter },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = lua_config("windwp/nvim-autopairs"),
    },
    {
        "windwp/nvim-ts-autotag",
        event = { VeryLazy, InsertEnter },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = lua_config("windwp/nvim-ts-autotag"),
    },
    -- Repeat
    {
        "tpope/vim-repeat",
        event = { VeryLazy, BufReadPre, BufNewFile },
    },
    -- Comment
    {
        "numToStr/Comment.nvim",
        event = { VeryLazy, BufReadPre, BufNewFile },
        config = lua_config("numToStr/Comment.nvim"),
    },
    -- Cursor motion
    {
        "smoka7/hop.nvim",
        event = { VeryLazy, BufReadPre, BufNewFile, CmdlineEnter },
        version = "*",
        config = lua_config("smoka7/hop.nvim"),
        keys = lua_keys("smoka7/hop.nvim"),
    },
    -- Surround
    {
        "kylechui/nvim-surround",
        version = "*",
        event = { VeryLazy, BufReadPre, BufNewFile },
        config = lua_config("kylechui/nvim-surround"),
    },
    -- Structure outlines
    {
        "liuchengxu/vista.vim",
        cmd = { "Vista" },
        event = { VeryLazy },
        init = lua_init("liuchengxu/vista.vim"),
        keys = lua_keys("liuchengxu/vista.vim"),
    },
    -- Url viewer
    {
        "axieax/urlview.nvim",
        cmd = { "UrlView" },
        config = lua_config("axieax/urlview.nvim"),
        keys = lua_keys("axieax/urlview.nvim"),
    },
}

return M
