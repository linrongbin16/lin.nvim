-- ---- Plugins Header ----

local function lua_config(repo)
    local function wrap()
        local config_path = "repo." .. repo:gsub("%.", "-") .. ".config"
        require(config_path)
    end
    return wrap
end

local function lua_keys(repo)
    local keys_path = "repo." .. repo:gsub("%.", "-") .. ".keys"
    return require(keys_path)
end

local function lua_init(repo)
    local function wrap()
        local init_path = "repo." .. repo:gsub("%.", "-") .. ".init"
        require(init_path)
    end
    return wrap
end

local function vim_config(repo)
    local function wrap()
        vim.cmd("source $HOME/.nvim/repo/" .. repo .. "/config.vim")
    end
    return wrap
end

local function vim_init(repo)
    local function wrap()
        vim.cmd("source $HOME/.nvim/repo/" .. repo .. "/init.vim")
    end
    return wrap
end

local VeryLazy = "VeryLazy"
local BufRead = "BufRead"
local CmdlineEnter = "CmdlineEnter"
local VimEnter = "VimEnter"
local InsertEnter = "InsertEnter"

return {

    -- ---- INFRASTRUCTURE ----

    {
        "nathom/filetype.nvim",
        init = lua_init("nathom/filetype.nvim"),
    },
    {
        "folke/lsp-colors.nvim",
    },
    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = true,
    },
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },
    {
        "stevearc/dressing.nvim",
        config = lua_config("stevearc/dressing.nvim"),
    },

    -- ---- COLORSCHEME ----

    {
        -- stars:3200, repo:https://github.com/folke/tokyonight.nvim
        "folke/tokyonight.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:2457, repo:https://github.com/nlknguyen/papercolor-theme
        "nlknguyen/papercolor-theme",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:2300, repo:https://github.com/catppuccin/nvim
        "catppuccin/nvim",
        lazy = true,
        priority = 1000,
        name = "catppuccin",
    },
    {
        -- stars:2000, repo:https://github.com/rebelot/kanagawa.nvim
        "rebelot/kanagawa.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:1978, repo:https://github.com/cocopon/iceberg.vim
        "cocopon/iceberg.vim",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:1900, repo:https://github.com/EdenEast/nightfox.nvim
        "EdenEast/nightfox.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:1700, repo:https://github.com/sainnhe/everforest
        "sainnhe/everforest",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:1564, repo:https://github.com/junegunn/seoul256.vim
        "junegunn/seoul256.vim",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:1379, repo:https://github.com/sickill/vim-monokai
        "sickill/vim-monokai",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:1300, repo:https://github.com/sainnhe/gruvbox-material
        "sainnhe/gruvbox-material",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:1300, repo:https://github.com/projekt0n/github-nvim-theme
        "projekt0n/github-nvim-theme",
        lazy = true,
        priority = 1000,
        branch = "0.0.x",
    },
    {
        -- stars:1200, repo:https://github.com/dracula/vim
        "dracula/vim",
        lazy = true,
        priority = 1000,
        name = "dracula",
    },
    {
        -- stars:1100, repo:https://github.com/sainnhe/sonokai
        "sainnhe/sonokai",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:1100, repo:https://github.com/mhartington/oceanic-next
        "mhartington/oceanic-next",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:1022, repo:https://github.com/jacoborus/tender.vim
        "jacoborus/tender.vim",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:912, repo:https://github.com/lifepillar/vim-solarized8
        "lifepillar/vim-solarized8",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:882, repo:https://github.com/ellisonleao/gruvbox.nvim
        "ellisonleao/gruvbox.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:858, repo:https://github.com/navarasu/onedark.nvim
        "navarasu/onedark.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:830, repo:https://github.com/tomasiser/vim-code-dark
        "tomasiser/vim-code-dark",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:830, repo:https://github.com/jnurmine/zenburn
        "jnurmine/zenburn",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:829, repo:https://github.com/romainl/apprentice
        "romainl/apprentice",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:804, repo:https://github.com/rose-pine/neovim
        "rose-pine/neovim",
        lazy = true,
        priority = 1000,
        name = "rose-pine",
    },
    {
        -- stars:761, repo:https://github.com/raphamorim/lucario
        "raphamorim/lucario",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:744, repo:https://github.com/srcery-colors/srcery-vim
        "srcery-colors/srcery-vim",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:717, repo:https://github.com/marko-cerovac/material.nvim
        "marko-cerovac/material.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:707, repo:https://github.com/pineapplegiant/spaceduck
        "pineapplegiant/spaceduck",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:698, repo:https://github.com/sainnhe/edge
        "sainnhe/edge",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:676, repo:https://github.com/ajmwagar/vim-deus
        "ajmwagar/vim-deus",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:624, repo:https://github.com/fenetikm/falcon
        "fenetikm/falcon",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:593, repo:https://github.com/nyoom-engineering/oxocarbon.nvim
        "nyoom-engineering/oxocarbon.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:577, repo:https://github.com/bluz71/vim-nightfly-colors
        "bluz71/vim-nightfly-colors",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:576, repo:https://github.com/preservim/vim-colors-pencil
        "preservim/vim-colors-pencil",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:571, repo:https://github.com/shaunsingh/nord.nvim
        "shaunsingh/nord.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:556, repo:https://github.com/bluz71/vim-moonfly-colors
        "bluz71/vim-moonfly-colors",
        lazy = true,
        priority = 1000,
    },
    {
        -- stars:548, repo:https://github.com/challenger-deep-theme/vim
        "challenger-deep-theme/vim",
        lazy = true,
        priority = 1000,
        name = "challenger-deep-theme",
    },
    {
        -- stars:530, repo:https://github.com/embark-theme/vim
        "embark-theme/vim",
        lazy = true,
        priority = 1000,
        name = "embark-theme",
    },

    -- ---- HIGHLIGHT ----

    {
        "RRethy/vim-illuminate",
        event = { VeryLazy, BufRead },
        init = lua_init("RRethy/vim-illuminate"),
        config = vim_config("RRethy/vim-illuminate"),
    },
    {
        "NvChad/nvim-colorizer.lua",
        event = { VeryLazy, BufRead },
        config = lua_config("NvChad/nvim-colorizer.lua"),
    },
    {
        "andymass/vim-matchup",
        event = { VeryLazy, BufRead },
        init = lua_init("andymass/vim-matchup"),
    },
    {
        "inkarkat/vim-mark",
        dependencies = { "inkarkat/vim-ingo-library" },
        event = { CmdlineEnter },
        init = vim_init("inkarkat/vim-mark"),
        keys = lua_keys("inkarkat/vim-mark"),
    },
    {
        "inkarkat/vim-ingo-library",
        lazy = true,
    },
    {
        "haya14busa/is.vim",
        event = { VeryLazy, BufRead, CmdlineEnter },
    },
    {
        "markonm/traces.vim",
        event = { CmdlineEnter },
    },

    -- ---- UI ----

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        event = { VimEnter },
        config = lua_config("nvim-tree/nvim-tree.lua"),
        keys = lua_keys("nvim-tree/nvim-tree.lua"),
    },
    -- Tabline
    {
        "akinsho/bufferline.nvim",
        version = "v3.*",
        event = { VeryLazy, BufRead },
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
        event = { VeryLazy, BufRead },
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
        branch = "main",
        lazy = true,
        config = lua_config("linrongbin16/lsp-progress.nvim"),
    },
    -- Winbar
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        event = { VeryLazy, BufRead },
        dependencies = { "SmiteshP/nvim-navic" },
        config = lua_config("utilyre/barbecue.nvim"),
    },
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        init = vim_init("SmiteshP/nvim-navic"),
    },
    -- Git
    {
        "airblade/vim-gitgutter",
        event = { VeryLazy, BufRead },
        init = vim_init("airblade/vim-gitgutter"),
        keys = lua_keys("airblade/vim-gitgutter"),
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
        config = vim_config("junegunn/fzf.vim"),
        keys = lua_keys("junegunn/fzf.vim"),
    },

    -- ---- TAGS ----

    -- Tags/structure outlines
    {
        "liuchengxu/vista.vim",
        cmd = { "Vista" },
        dependencies = { "ludovicchabant/vim-gutentags" },
        keys = lua_keys("liuchengxu/vista.vim"),
    },
    {
        "ludovicchabant/vim-gutentags",
        event = { VeryLazy, BufRead },
        init = vim_init("ludovicchabant/vim-gutentags"),
    },

    -- ---- LSP ----

    -- Lsp server management
    {
        "williamboman/mason.nvim",
        event = { VeryLazy, BufRead },
        config = lua_config("williamboman/mason.nvim"),
        keys = lua_keys("williamboman/mason.nvim"),
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = { VeryLazy, BufRead },
        dependencies = { "williamboman/mason.nvim" },
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { VeryLazy, BufRead },
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = { VeryLazy, BufRead },
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
        event = { InsertEnter, CmdlineEnter },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "quangnguyen30192/cmp-nvim-tags",
        },
        config = lua_config("hrsh7th/nvim-cmp"),
    },
    {
        "hrsh7th/cmp-nvim-lsp",
        event = { InsertEnter, CmdlineEnter },
    },
    {
        "hrsh7th/cmp-buffer",
        event = { InsertEnter, CmdlineEnter },
    },
    {
        "hrsh7th/cmp-path",
        event = { InsertEnter, CmdlineEnter },
    },
    {
        "hrsh7th/cmp-cmdline",
        event = { InsertEnter, CmdlineEnter },
    },
    {
        "L3MON4D3/LuaSnip",
        event = { InsertEnter, CmdlineEnter },
        version = "1.*",
    },
    {
        "saadparwaiz1/cmp_luasnip",
        event = { InsertEnter, CmdlineEnter },
        dependencies = { "L3MON4D3/LuaSnip" },
    },
    {
        "quangnguyen30192/cmp-nvim-tags",
        event = { InsertEnter, CmdlineEnter },
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
        "lukas-reineke/lsp-format.nvim",
        config = function()
            require("lsp-format").setup({})
        end,
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
        event = { CmdlineEnter },
        config = lua_config("phaazon/hop.nvim"),
        keys = lua_keys("phaazon/hop.nvim"),
    },
    {
        "ggandor/leap.nvim",
        event = { VeryLazy, BufRead },
        dependencies = { "tpope/vim-repeat" },
        config = lua_config("ggandor/leap.nvim"),
    },

    -- ---- GIT ----

    {
        "f-person/git-blame.nvim",
        event = { CmdlineEnter },
        init = vim_init("f-person/git-blame.nvim"),
        keys = lua_keys("f-person/git-blame.nvim"),
    },
    -- Open git link In browser
    {
        "linrongbin16/gitlinker.nvim",
        lazy = true,
        branch = "master",
        config = lua_config("linrongbin16/gitlinker.nvim"),
        keys = lua_keys("linrongbin16/gitlinker.nvim"),
    },

    -- ---- ENHANCEMENT ----

    -- Auto pair/close
    {
        "windwp/nvim-autopairs",
        event = { InsertEnter },
        config = lua_config("windwp/nvim-autopairs"),
    },
    {
        "alvan/vim-closetag",
        event = { InsertEnter },
        init = vim_init("alvan/vim-closetag"),
    },
    -- Comment
    {
        "numToStr/Comment.nvim",
        event = { VeryLazy, BufRead },
        config = lua_config("numToStr/Comment.nvim"),
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
    -- Terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        event = { CmdlineEnter },
        config = lua_config("akinsho/toggleterm.nvim"),
        keys = lua_keys("akinsho/toggleterm.nvim"),
    },
    -- Undo tree
    {
        "mbbill/undotree",
        event = { CmdlineEnter },
        keys = lua_keys("mbbill/undotree"),
    },
    -- Other
    {
        "tpope/vim-repeat",
        event = { VeryLazy, BufRead },
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = { VeryLazy, BufRead },
        config = lua_config("kylechui/nvim-surround"),
    },
    {
        "editorconfig/editorconfig-vim",
        event = { InsertEnter },
    },
    {
        "axieax/urlview.nvim",
        cmd = { "UrlView" },
        config = lua_config("axieax/urlview.nvim"),
        keys = lua_keys("axieax/urlview.nvim"),
    },
}

-- ---- Plugins Footer ----