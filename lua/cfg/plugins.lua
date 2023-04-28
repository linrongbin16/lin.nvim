-- ---- Plugins ----

local function lua_config(repo)
    return function()
        local config_path = "repo." .. repo:gsub("%.", "-") .. ".config"
        require(config_path)
    end
end

local function lua_keys(repo)
    local keys_path = "repo." .. repo:gsub("%.", "-") .. ".keys"
    return require(keys_path)
end

local function lua_init(repo)
    return function()
        local init_path = "repo." .. repo:gsub("%.", "-") .. ".init"
        require(init_path)
    end
end

local function vim_config(repo)
    return function()
        vim.cmd("source $HOME/.nvim/repo/" .. repo .. "/config.vim")
    end
end

local function vim_init(repo)
    return function()
        vim.cmd("source $HOME/.nvim/repo/" .. repo .. "/init.vim")
    end
end

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

    -- ---- COLORSCHEME ----

    {
        "bluz71/vim-moonfly-colors",
        lazy = true,
        priority = 1000,
    },
    {
        "bluz71/vim-nightfly-colors",
        lazy = true,
        priority = 1000,
    },
    {
        "catppuccin/nvim",
        lazy = true,
        priority = 1000,
        name = "catppuccin",
    },
    {
        "challenger-deep-theme/vim",
        lazy = true,
        priority = 1000,
        name = "challenger-deep-theme",
    },
    {
        "cocopon/iceberg.vim",
        lazy = true,
        priority = 1000,
    },
    {
        "dracula/vim",
        lazy = true,
        priority = 1000,
        name = "dracula",
    },
    {
        "EdenEast/nightfox.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "ellisonleao/gruvbox.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "embark-theme/vim",
        lazy = true,
        priority = 1000,
        name = "embark-theme",
    },
    {
        "fenetikm/falcon",
        lazy = true,
        priority = 1000,
    },
    {
        "folke/tokyonight.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "jacoborus/tender.vim",
        lazy = true,
        priority = 1000,
    },
    {
        "jnurmine/zenburn",
        lazy = true,
        priority = 1000,
    },
    {
        "junegunn/seoul256.vim",
        lazy = true,
        priority = 1000,
    },
    {
        "lifepillar/vim-solarized8",
        lazy = true,
        priority = 1000,
    },
    {
        "marko-cerovac/material.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "navarasu/onedark.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "nlknguyen/papercolor-theme",
        lazy = true,
        priority = 1000,
    },
    {
        "nyoom-engineering/oxocarbon.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "pineapplegiant/spaceduck",
        lazy = true,
        priority = 1000,
    },
    {
        "preservim/vim-colors-pencil",
        lazy = true,
        priority = 1000,
    },
    {
        "projekt0n/github-nvim-theme",
        lazy = true,
        priority = 1000,
        branch = "0.0.x",
    },
    {
        "raphamorim/lucario",
        lazy = true,
        priority = 1000,
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "romainl/apprentice",
        lazy = true,
        priority = 1000,
    },
    {
        "rose-pine/neovim",
        lazy = true,
        priority = 1000,
        name = "rose-pine",
    },
    {
        "sainnhe/edge",
        lazy = true,
        priority = 1000,
    },
    {
        "sainnhe/everforest",
        lazy = true,
        priority = 1000,
    },
    {
        "sainnhe/gruvbox-material",
        lazy = true,
        priority = 1000,
    },
    {
        "sainnhe/sonokai",
        lazy = true,
        priority = 1000,
    },
    {
        "shaunsingh/nord.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "sickill/vim-monokai",
        lazy = true,
        priority = 1000,
    },
    {
        "srcery-colors/srcery-vim",
        lazy = true,
        priority = 1000,
    },
    {
        "tomasiser/vim-code-dark",
        lazy = true,
        priority = 1000,
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
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        cmd = { "Telescope" },
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim",
            "nvim-telescope/telescope-live-grep-args.nvim",
            "debugloop/telescope-undo.nvim",
        },
        config = lua_config("nvim-telescope/telescope.nvim"),
        keys = lua_keys("nvim-telescope/telescope.nvim"),
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        lazy = true,
    },
    {
        "nvim-telescope/telescope-live-grep-args.nvim",
        lazy = true,
    },
    {
        "debugloop/telescope-undo.nvim",
        lazy = true,
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
}

-- Check if `user_plugins` exist
local found_user_plugins, user_plugins = pcall(require, "cfg.user_plugins")

if found_user_plugins then
    for _, plugin in ipairs(user_plugins) do
        table.insert(M, plugin)
    end
end

return M