-- ---- Plugins ----

local lua_keys = require("builtin.utils.plugin").lua_keys
local lua_init = require("builtin.utils.plugin").lua_init
local lua_config = require("builtin.utils.plugin").lua_config
local vim_init = require("builtin.utils.plugin").vim_init
local vim_config = require("builtin.utils.plugin").vim_config

local VeryLazy = "VeryLazy"
local BufNewFile = "BufNewFile"
local BufRead = "BufRead"
local CmdlineEnter = "CmdlineEnter"
local VimEnter = "VimEnter"
local InsertEnter = "InsertEnter"

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
        event = { VeryLazy, BufRead, BufNewFile, CmdlineEnter },
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        config = lua_config("nvim-treesitter/nvim-treesitter"),
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { VeryLazy, BufRead, BufNewFile },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = lua_config("nvim-treesitter/nvim-treesitter-context"),
    },
    {
        "RRethy/vim-illuminate",
        event = { VeryLazy, BufRead, BufNewFile },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = lua_config("RRethy/vim-illuminate"),
    },
    {
        "NvChad/nvim-colorizer.lua",
        event = { VeryLazy, BufRead, BufNewFile },
        config = lua_config("NvChad/nvim-colorizer.lua"),
    },
    {
        "andymass/vim-matchup",
        event = { VeryLazy, BufRead, BufNewFile },
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
        "haya14busa/is.vim",
        event = { VeryLazy, BufRead, BufNewFile, CmdlineEnter },
    },
    {
        "markonm/traces.vim",
        event = { CmdlineEnter },
    },

    -- ---- UI ----

    -- File explorer
    -- {
    --     "nvim-tree/nvim-tree.lua",
    --     event = { VimEnter },
    --     config = lua_config("nvim-tree/nvim-tree.lua"),
    --     keys = lua_keys("nvim-tree/nvim-tree.lua"),
    -- },
    -- {
    --     "ms-jpq/chadtree",
    --     event = { VimEnter },
    --     branch = "chad",
    --     build = "python3 -m chadtree deps",
    --     init = lua_init("ms-jpq/chadtree"),
    -- },
    {
        "MunifTanjim/nui.nvim",
        lazy = true,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        event = { VimEnter },
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
        event = { VeryLazy, BufRead, BufNewFile },
        dependencies = { "moll/vim-bbye" },
        config = lua_config("akinsho/bufferline.nvim"),
        keys = lua_keys("akinsho/bufferline.nvim"),
    },
    -- Indentline
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { VeryLazy, BufRead, BufNewFile },
    },
    -- Statusline
    {
        "linrongbin16/lsp-progress.nvim",
        event = { VimEnter },
        config = lua_config("linrongbin16/lsp-progress.nvim"),
    },
    {
        "nvim-lualine/lualine.nvim",
        event = { VimEnter },
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
        event = { VeryLazy, BufRead, BufNewFile },
        dependencies = { "SmiteshP/nvim-navic" },
        config = lua_config("utilyre/barbecue.nvim"),
    },
    -- Git
    {
        "airblade/vim-gitgutter",
        event = { VeryLazy, BufRead, BufNewFile },
        init = lua_init("airblade/vim-gitgutter"),
        keys = lua_keys("airblade/vim-gitgutter"),
    },
    -- UI improvement
    {
        "stevearc/dressing.nvim",
        event = { VeryLazy, BufRead, BufNewFile },
        dependencies = {
            "junegunn/fzf",
            "junegunn/fzf.vim",
            "linrongbin16/fzfx.vim",
        },
        config = lua_config("stevearc/dressing.nvim"),
    },

    -- ---- SEARCH ----

    {
        "junegunn/fzf",
        event = { CmdlineEnter },
        build = ":call fzf#install()",
    },
    {
        "junegunn/fzf.vim",
        event = { CmdlineEnter },
        dependencies = { "junegunn/fzf" },
        init = vim_init("junegunn/fzf.vim"),
        keys = lua_keys("junegunn/fzf.vim"),
    },
    {
        "linrongbin16/fzfx.vim",
        event = { CmdlineEnter },
        dependencies = { "junegunn/fzf", "junegunn/fzf.vim" },
        keys = lua_keys("linrongbin16/fzfx.vim"),
    },

    -- ---- LSP ----

    -- Lsp server management
    {
        "williamboman/mason.nvim",
        event = { VeryLazy, BufRead, BufNewFile, CmdlineEnter },
        build = ":MasonUpdate",
        config = lua_config("williamboman/mason.nvim"),
        keys = lua_keys("williamboman/mason.nvim"),
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = { VeryLazy, BufRead, BufNewFile, CmdlineEnter },
        dependencies = { "williamboman/mason.nvim" },
        config = lua_config("williamboman/mason-lspconfig.nvim"),
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { VeryLazy, BufRead, BufNewFile, CmdlineEnter },
        config = lua_config("jose-elias-alvarez/null-ls.nvim"),
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = { VeryLazy, BufRead, BufNewFile, CmdlineEnter },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "jose-elias-alvarez/null-ls.nvim",
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
        event = { VeryLazy, InsertEnter, CmdlineEnter },
    },
    {
        "FelipeLema/cmp-async-path",
        event = { VeryLazy, InsertEnter, CmdlineEnter },
    },
    {
        "L3MON4D3/LuaSnip",
        event = { VeryLazy, InsertEnter },
        version = "1.*",
    },
    {
        "saadparwaiz1/cmp_luasnip",
        event = { VeryLazy, InsertEnter },
        dependencies = { "L3MON4D3/LuaSnip" },
    },
    {
        "hrsh7th/cmp-cmdline",
        event = { VeryLazy, InsertEnter, CmdlineEnter },
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
    -- Format on save
    {
        "linrongbin16/lspformatter.nvim",
        event = { VeryLazy, BufRead, BufNewFile },
        config = lua_config("linrongbin16/lspformatter.nvim"),
    },

    -- ---- SPECIFIC LANGUAGE SUPPORT ----

    -- Markdown
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
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
        config = lua_config("windwp/nvim-autopairs"),
    },
    {
        "alvan/vim-closetag",
        init = vim_init("alvan/vim-closetag"),
    },
    -- Repeat
    {
        "tpope/vim-repeat",
        event = { VeryLazy, BufRead, BufNewFile },
    },
    -- Comment
    {
        "numToStr/Comment.nvim",
        event = { VeryLazy, BufRead, BufNewFile },
        config = lua_config("numToStr/Comment.nvim"),
    },
    -- Cursor motion
    {
        "smoka7/hop.nvim",
        event = { VeryLazy, BufRead, BufNewFile, CmdlineEnter },
        version = "*",
        config = lua_config("smoka7/hop.nvim"),
        keys = lua_keys("smoka7/hop.nvim"),
    },
    {
        "ggandor/leap.nvim",
        event = { VeryLazy, BufRead, BufNewFile },
        dependencies = { "tpope/vim-repeat" },
        config = lua_config("ggandor/leap.nvim"),
    },
    -- Surround
    {
        "kylechui/nvim-surround",
        version = "*",
        event = { VeryLazy, BufRead, BufNewFile },
        config = lua_config("kylechui/nvim-surround"),
    },
    -- Structure outlines
    {
        "liuchengxu/vista.vim",
        event = { VeryLazy, CmdlineEnter },
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
    -- Terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        event = { VeryLazy, CmdlineEnter },
        config = lua_config("akinsho/toggleterm.nvim"),
        keys = lua_keys("akinsho/toggleterm.nvim"),
    },
    -- Generate documents
    {
        "danymat/neogen",
        cmd = { "Neogen" },
        dependencies = { "L3MON4D3/LuaSnip" },
        config = lua_config("danymat/neogen"),
        keys = lua_keys("danymat/neogen"),
    },
    -- Undo tree
    {
        "mbbill/undotree",
        event = { VeryLazy, CmdlineEnter },
        init = lua_init("mbbill/undotree"),
        keys = lua_keys("mbbill/undotree"),
    },
    -- Yank
    {
        "gbprod/yanky.nvim",
        config = lua_config("gbprod/yanky.nvim"),
        keys = lua_keys("gbprod/yanky.nvim"),
    },
}

return M