-- ---- Plugins ----

local const = require("cfg.const")

local lua_keys = require("cfg.plugins_util").lua_keys
local lua_init = require("cfg.plugins_util").lua_init
local lua_config = require("cfg.plugins_util").lua_config
local vim_init = require("cfg.plugins_util").vim_init
local vim_config = require("cfg.plugins_util").vim_config

local VeryLazy = "VeryLazy"
local BufRead = "BufRead"
local BufNewFile = "BufNewFile"
local CmdlineEnter = "CmdlineEnter"
local VimEnter = "VimEnter"
local InsertEnter = "InsertEnter"

local M = {

    -- ---- INFRASTRUCTURE ----

    {
        "folke/lsp-colors.nvim",
    },
    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },
    {
        "neovim/nvim-lspconfig",
        config = lua_config("neovim/nvim-lspconfig"),
        lazy = true,
    },
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },

    -- ---- HIGHLIGHT ----

    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        event = { VeryLazy, BufRead, BufNewFile, CmdlineEnter },
        config = lua_config("nvim-treesitter/nvim-treesitter"),
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = { VeryLazy, BufRead, BufNewFile },
        config = lua_config("nvim-treesitter/nvim-treesitter-context"),
    },
    {
        "RRethy/vim-illuminate",
        event = { VeryLazy, BufRead, BufNewFile },
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
        init = lua_init("andymass/vim-matchup"),
    },
    {
        "inkarkat/vim-mark",
        dependencies = { "inkarkat/vim-ingo-library" },
        event = { CmdlineEnter },
        init = lua_init("inkarkat/vim-mark"),
        keys = lua_keys("inkarkat/vim-mark"),
    },
    {
        "inkarkat/vim-ingo-library",
        lazy = true,
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
        "nvim-neo-tree/neo-tree.nvim",
        event = { VimEnter },
        branch = "v2.x",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        init = lua_init("nvim-neo-tree/neo-tree.nvim"),
        config = lua_config("nvim-neo-tree/neo-tree.nvim"),
        keys = lua_keys("nvim-neo-tree/neo-tree.nvim"),
    },
    {
        "MunifTanjim/nui.nvim",
        lazy = true,
    },
    -- Tabline
    {
        "akinsho/bufferline.nvim",
        version = "v3.*",
        event = { VeryLazy, BufRead, BufNewFile },
        dependencies = { "moll/vim-bbye" },
        config = lua_config("akinsho/bufferline.nvim"),
        keys = lua_keys("akinsho/bufferline.nvim"),
    },
    {
        "moll/vim-bbye",
        cmd = { "Bdelete", "Bwipeout" },
        keys = lua_keys("moll/vim-bbye"),
    },
    -- Indentline
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { VeryLazy, BufRead, BufNewFile },
    },
    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        event = { VimEnter },
        dependencies = { "linrongbin16/lsp-progress.nvim" },
        config = lua_config("nvim-lualine/lualine.nvim"),
    },
    {
        "linrongbin16/lsp-progress.nvim",
        event = { VimEnter },
        config = lua_config("linrongbin16/lsp-progress.nvim"),
    },
    -- Winbar
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        event = { VeryLazy, BufRead, BufNewFile },
        dependencies = { "SmiteshP/nvim-navic" },
        config = lua_config("utilyre/barbecue.nvim"),
    },
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        init = lua_init("SmiteshP/nvim-navic"),
    },
    -- Git
    {
        "airblade/vim-gitgutter",
        event = { VeryLazy, BufRead, BufNewFile },
        init = lua_init("airblade/vim-gitgutter"),
        keys = lua_keys("airblade/vim-gitgutter"),
    },
    {
        "stevearc/dressing.nvim",
        event = { VeryLazy, BufRead, BufNewFile },
        config = lua_config("stevearc/dressing.nvim"),
    },

    -- ---- SEARCH ----

    {
        "junegunn/fzf",
        event = { CmdlineEnter },
        build = ":call fzf#install()",
    },
    const.os.is_windows and {
        "junegunn/fzf.vim",
        event = { CmdlineEnter },
        dependencies = { "junegunn/fzf" },
        init = vim_init("junegunn/fzf.vim"),
        config = vim_config("junegunn/fzf.vim"),
        keys = const.os.is_windows and lua_keys("junegunn/fzf.vim"),
    } or {
        "ibhagwan/fzf-lua",
        cmd = { "FzfLua" },
        dependencies = { "junegunn/fzf" },
        config = lua_config("ibhagwan/fzf-lua"),
        keys = lua_keys("ibhagwan/fzf-lua"),
    },

    -- ---- TAGS ----

    -- Tags generator
    {
        "ludovicchabant/vim-gutentags",
        event = { VeryLazy, BufRead, BufNewFile },
        init = vim_init("ludovicchabant/vim-gutentags"),
    },

    -- ---- LSP ----

    -- Lsp server management
    {
        "williamboman/mason.nvim",
        event = { VeryLazy, BufRead, BufNewFile },
        config = lua_config("williamboman/mason.nvim"),
        keys = lua_keys("williamboman/mason.nvim"),
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = { VeryLazy, BufRead, BufNewFile },
        dependencies = { "williamboman/mason.nvim" },
        config = lua_config("williamboman/mason-lspconfig.nvim"),
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { VeryLazy, BufRead, BufNewFile },
        config = lua_config("jose-elias-alvarez/null-ls.nvim"),
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = { VeryLazy, BufRead, BufNewFile },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "jose-elias-alvarez/null-ls.nvim",
        },
        config = lua_config("jay-babu/mason-null-ls.nvim"),
    },
    -- Auto-complete engine
    {
        "hrsh7th/nvim-cmp",
        event = { VeryLazy, InsertEnter, CmdlineEnter },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "FelipeLema/cmp-async-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-cmdline",
        },
        config = lua_config("hrsh7th/nvim-cmp"),
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
        "DNLHC/glance.nvim",
        cmd = { "Glance" },
        config = lua_config("DNLHC/glance.nvim"),
    },
    {
        "onsails/lspkind.nvim",
        lazy = true,
    },
    {
        "linrongbin16/lspformatter.nvim",
        event = { VeryLazy, BufRead, BufNewFile },
        dependencies = "linrongbin16/logger.nvim",
        config = lua_config("linrongbin16/lspformatter.nvim"),
    },
    {
        "linrongbin16/logger.nvim",
        lazy = true,
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

    -- ---- CURSOR MOTION ----

    {
        "phaazon/hop.nvim",
        branch = "v2",
        event = { VeryLazy, CmdlineEnter },
        config = lua_config("phaazon/hop.nvim"),
        keys = lua_keys("phaazon/hop.nvim"),
    },
    {
        "ggandor/leap.nvim",
        event = { VeryLazy, BufRead, BufNewFile },
        dependencies = { "tpope/vim-repeat" },
        config = lua_config("ggandor/leap.nvim"),
    },

    -- ---- GIT ----

    {
        "f-person/git-blame.nvim",
        event = { VeryLazy, CmdlineEnter },
        init = lua_init("f-person/git-blame.nvim"),
        keys = lua_keys("f-person/git-blame.nvim"),
    },
    -- Open git link In browser
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
    -- Comment
    {
        "numToStr/Comment.nvim",
        event = { VeryLazy, BufRead, BufNewFile },
        config = lua_config("numToStr/Comment.nvim"),
    },
    -- Other
    {
        "tpope/vim-repeat",
        event = { VeryLazy, BufRead, BufNewFile },
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = { VeryLazy, BufRead, BufNewFile },
        config = lua_config("kylechui/nvim-surround"),
    },
    -- Structure outlines based on tags
    {
        "liuchengxu/vista.vim",
        cmd = { "Vista" },
        dependencies = { "ludovicchabant/vim-gutentags" },
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
        "kkoomen/vim-doge",
        cmd = { "DogeGenerate" },
        build = require("cfg.const").os.is_macos
                and "npm i --no-save && npm run build:binary:unix"
            or ":call doge#install()",
        init = vim_init("kkoomen/vim-doge"),
        keys = lua_keys("kkoomen/vim-doge"),
    },
    -- Undo tree
    {
        "mbbill/undotree",
        event = { VeryLazy, CmdlineEnter },
        init = lua_init("mbbill/undotree"),
        keys = lua_keys("mbbill/undotree"),
    },
}

-- Add user plugins
local found_user_plugins, user_plugins = pcall(require, "cfg.user_plugins")
if found_user_plugins then
    for _, plugin in ipairs(user_plugins) do
        table.insert(M, plugin)
    end
end

return M