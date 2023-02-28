-- ---- Plugins Header ----

return {

    -- ---- INFRASTRUCTURE ----

    {
        "nathom/filetype.nvim",
        init = function()
            require("repo.nathom.filetype-nvim.init")
        end,
    },
    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = true,
    },

    -- ---- COLORSCHEME ----

    {
        "folke/lsp-colors.nvim",
        lazy = true,
    },
    {
        "bluz71/vim-nightfly-colors",
        lazy = true,
        priority = 1000,
    },
    {
        "bluz71/vim-moonfly-colors",
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
        name = "challenger-deep",
    },
    {
        "cocopon/iceberg.vim",
        lazy = true,
        priority = 1000,
    },
    {
        "EdenEast/nightfox.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "embark-theme/vim",
        lazy = true,
        priority = 1000,
        name = "embark",
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
        branch = "main",
    },
    -- inherit 'lifepillar/vim-solarized8'
    {
        "ishan9299/nvim-solarized-lua",
        lazy = true,
        priority = 1000,
    },
    {
        "junegunn/seoul256.vim",
        lazy = true,
        priority = 1000,
        init = function()
            vim.cmd("source $HOME/.nvim/repo/junegunn/seoul256.vim/init.vim")
        end,
    },
    -- inherit sainnhe/gruvbox-material
    {
        "luisiacc/gruvbox-baby",
        lazy = true,
        priority = 1000,
        branch = "main",
    },
    -- inherit kaicataldo/material.vim
    {
        "marko-cerovac/material.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "mhartington/oceanic-next",
        lazy = true,
        priority = 1000,
    },
    -- inherit dracula/vim
    {
        "Mofiqul/dracula.nvim",
        lazy = true,
        priority = 1000,
    },
    -- inherit joshdick/onedark.vim, tomasiser/vim-code-dark, olimorris/onedarkpro.nvim
    {
        "navarasu/onedark.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "NLKNguyen/papercolor-theme",
        lazy = true,
        priority = 1000,
    },
    {
        "pineapplegiant/spaceduck",
        lazy = true,
        priority = 1000,
        branch = "main",
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
        "Rigellute/rigel",
        lazy = true,
        priority = 1000,
    },
    {
        "romainl/Apprentice",
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
    -- inherit sickill/vim-monokai
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
        "srcery-colors/srcery-vim",
        lazy = true,
        priority = 1000,
    },

    -- ---- HIGHLIGHT ----

    {
        "RRethy/vim-illuminate",
        event = { "VeryLazy", "BufReadPost" },
        init = function()
            require("repo.RRethy.vim-illuminate.init")
        end,
        config = function()
            vim.cmd("source $HOME/.nvim/repo/RRethy/vim-illuminate/config.vim")
        end,
    },
    -- {
    --     "NvChad/nvim-colorizer.lua",
    --     event = { "BufReadPost", "CmdlineEnter" },
    --     config = function()
    --         require("repo.NvChad.nvim-colorizer-lua.config")
    --     end,
    -- },
    {
        "uga-rosa/ccc.nvim",
        event = { "BufReadPost", "CmdlineEnter" },
        config = function()
            require("repo.uga-rosa.ccc-nvim.config")
        end,
    },
    {
        "andymass/vim-matchup",
        event = { "VeryLazy", "BufReadPost" },
        init = function()
            require("repo.andymass.vim-matchup.init")
        end,
    },
    {
        "inkarkat/vim-mark",
        dependencies = { "inkarkat/vim-ingo-library" },
        event = { "CmdlineEnter" },
        init = function()
            vim.cmd("source $HOME/.nvim/repo/inkarkat/vim-mark/init.vim")
        end,
        keys = require("repo.inkarkat.vim-mark.keys"),
    },
    {
        "inkarkat/vim-ingo-library",
        lazy = true,
    },
    {
        "haya14busa/is.vim",
        event = { "CmdlineEnter" },
    },
    {
        "markonm/traces.vim",
        event = { "CmdlineEnter" },
    },

    -- ---- UI ----

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        event = { "VimEnter" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("repo.nvim-tree.nvim-tree-lua.config")
        end,
        keys = require("repo.nvim-tree.nvim-tree-lua.keys"),
    },
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },
    -- Tabline
    {
        "akinsho/bufferline.nvim",
        version = "v3.*",
        event = { "VeryLazy", "BufReadPost" },
        dependencies = { "nvim-tree/nvim-web-devicons", "moll/vim-bbye" },
        config = function()
            require("repo.akinsho.bufferline-nvim.config")
        end,
        keys = require("repo.akinsho.bufferline-nvim.keys"),
    },
    {
        "moll/vim-bbye",
        cmd = { "Bdelete", "Bwipeout" },
        keys = require("repo.moll.vim-bbye.keys"),
    },
    -- Indentline
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost" },
    },
    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        event = { "VimEnter" },
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "linrongbin16/lsp-progress.nvim",
        },
        config = function()
            require("repo.nvim-lualine.lualine-nvim.config")
        end,
    },
    {
        "linrongbin16/lsp-progress.nvim",
        branch = "main",
        lazy = true,
        config = function()
            require("repo.linrongbin16.lsp-progress-nvim.config")
        end,
    },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        event = { "BufReadPost" },
        dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
        config = function()
            require("repo.utilyre.barbecue-nvim.config")
        end,
    },
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        dependencies = { "neovim/nvim-lspconfig" },
        init = function()
            vim.cmd("source $HOME/.nvim/repo/SmiteshP/nvim-navic/init.vim")
        end,
    },
    -- Git
    {
        "airblade/vim-gitgutter",
        event = { "BufReadPost" },
        init = function()
            vim.cmd("source $HOME/.nvim/repo/airblade/vim-gitgutter/init.vim")
        end,
        keys = require("repo.airblade.vim-gitgutter.keys"),
    },
    -- UI hooks
    {
        "stevearc/dressing.nvim",
        event = { "VimEnter" },
        config = function()
            require("repo.stevearc.dressing-nvim.config")
        end,
    },

    -- ---- SEARCH ----

    {
        "junegunn/fzf",
        event = { "CmdlineEnter" },
        build = ":call fzf#install()",
    },
    {
        "junegunn/fzf.vim",
        event = { "CmdlineEnter" },
        dependencies = { "junegunn/fzf" },
        init = function()
            vim.cmd("source $HOME/.nvim/repo/junegunn/fzf.vim/init.vim")
        end,
        config = function()
            vim.cmd("source $HOME/.nvim/repo/junegunn/fzf.vim/config.vim")
        end,
        keys = require("repo.junegunn.fzf-vim.keys"),
    },

    -- ---- TAGS ----

    -- Tags/structure outlines
    {
        "liuchengxu/vista.vim",
        cmd = { "Vista" },
        dependencies = { "ludovicchabant/vim-gutentags" },
        keys = require("repo.liuchengxu.vista-vim.keys"),
    },
    {
        "ludovicchabant/vim-gutentags",
        event = { "BufReadPost" },
        init = function()
            vim.cmd(
                "source $HOME/.nvim/repo/ludovicchabant/vim-gutentags/init.vim"
            )
        end,
    },

    -- ---- LSP ----

    -- LSP
    {
        "williamboman/mason.nvim",
        event = { "VeryLazy", "BufReadPost" },
        config = function()
            require("repo.williamboman.mason-nvim.config")
        end,
        keys = require("repo.williamboman.mason-nvim.keys"),
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "VeryLazy", "BufReadPost" },
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("repo.williamboman.mason-lspconfig-nvim.config")
        end,
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "VeryLazy", "BufReadPost" },
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = { "VeryLazy", "BufReadPost" },
        dependencies = {
            "williamboman/mason.nvim",
            "jose-elias-alvarez/null-ls.nvim",
        },
    },
    -- Auto-complete engine
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "quangnguyen30192/cmp-nvim-tags",
        },
        config = function()
            require("repo.hrsh7th.nvim-cmp.config")
        end,
    },
    {
        "hrsh7th/cmp-nvim-lsp",
        event = { "InsertEnter", "CmdlineEnter" },
    },
    {
        "hrsh7th/cmp-buffer",
        event = { "InsertEnter", "CmdlineEnter" },
    },
    {
        "hrsh7th/cmp-path",
        event = { "InsertEnter", "CmdlineEnter" },
    },
    {
        "hrsh7th/cmp-cmdline",
        event = { "InsertEnter", "CmdlineEnter" },
    },
    {
        "L3MON4D3/LuaSnip",
        event = { "InsertEnter", "CmdlineEnter" },
        version = "1.*",
    },
    {
        "saadparwaiz1/cmp_luasnip",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = { "L3MON4D3/LuaSnip" },
    },
    {
        "quangnguyen30192/cmp-nvim-tags",
        event = { "InsertEnter", "CmdlineEnter" },
    },
    {
        "DNLHC/glance.nvim",
        cmd = { "Glance" },
        config = function()
            require("repo.DNLHC.glance-nvim.config")
        end,
    },
    {
        "onsails/lspkind.nvim",
        lazy = true,
    },

    -- ---- SPECIFIC SUPPORT ----

    -- Markdown
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = { "markdown" },
        init = function()
            require("repo.iamcco.markdown-preview-nvim.init")
        end,
        keys = require("repo.iamcco.markdown-preview-nvim.keys"),
    },
    -- Lex/yacc, flex/bison
    {
        "justinmk/vim-syntax-extra",
        ft = { "lex", "flex", "yacc", "bison" },
    },
    -- LLVM
    {
        "rhysd/vim-llvm",
        ft = { "llvm", "mir", "mlir", "tablegen" },
        init = function()
            vim.cmd("source $HOME/.nvim/repo/rhysd/vim-llvm/init.vim")
        end,
    },
    -- Hive
    {
        "zebradil/hive.vim",
        ft = { "hive" },
    },
    -- Slim
    {
        "slim-template/vim-slim",
        ft = { "slim" },
    },

    -- ---- KEY BINDING ----

    -- Key mappings
    {
        "folke/which-key.nvim",
        cmd = { "WhichKey" },
        config = function()
            require("repo.folke.which-key-nvim.config")
        end,
        keys = require("repo.folke.which-key-nvim.keys"),
    },

    -- ---- CURSOR MOTION ----

    {
        "phaazon/hop.nvim",
        branch = "v2",
        event = { "CmdlineEnter" },
        config = function()
            require("repo.phaazon.hop-nvim.config")
        end,
        keys = require("repo.phaazon.hop-nvim.keys"),
    },
    {
        "ggandor/leap.nvim",
        event = { "BufReadPost" },
        dependencies = { "tpope/vim-repeat" },
        config = function()
            require("repo.ggandor.leap-nvim.config")
        end,
    },

    -- ---- GIT ----

    {
        "f-person/git-blame.nvim",
        cmd = {
            "GitBlameOpenCommitURL",
            "GitBlameToggle",
            "GitBlameEnable",
            "GitBlameDisable",
            "GitBlameCopySHA",
            "GitBlameCopyCommitURL",
        },
        init = function()
            vim.cmd("source $HOME/.nvim/repo/f-person/git-blame.nvim/init.vim")
        end,
        keys = require("repo.f-person.git-blame-nvim.keys"),
    },
    -- Open git link In browser
    {
        "linrongbin16/gitlinker.nvim",
        lazy = true,
        branch = "master",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("repo.linrongbin16.gitlinker-nvim.config")
        end,
        keys = require("repo.linrongbin16.gitlinker-nvim.keys"),
    },

    -- ---- ENHANCEMENT ----

    -- Auto pair/close
    {
        "windwp/nvim-autopairs",
        event = { "InsertEnter" },
        config = function()
            require("repo.windwp.nvim-autopairs.config")
        end,
    },
    {
        "alvan/vim-closetag",
        event = { "InsertEnter" },
        init = function()
            vim.cmd("source $HOME/.nvim/repo/alvan/vim-closetag/init.vim")
        end,
    },
    -- Comment
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPost" },
        config = function()
            require("repo.numToStr.Comment-nvim.config")
        end,
    },
    -- Generate documents
    {
        "kkoomen/vim-doge",
        cmd = { "DogeGenerate" },
        build = "npm i --no-save && npm run build:binary:unix",
        init = function()
            vim.cmd("source $HOME/.nvim/repo/kkoomen/vim-doge/init.vim")
        end,
        keys = require("repo.kkoomen.vim-doge.keys"),
    },
    -- Terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        cmd = {
            "TermExec",
            "ToggleTerm",
            "ToggleTermToggleAll",
            "ToggleTermSendVisualLines",
            "ToggleTermSendVisualSelection",
            "ToggleTermSendCurrentLine",
            "ToggleTermSetName",
        },
        config = function()
            require("repo.akinsho.toggleterm-nvim.config")
        end,
        keys = require("repo.akinsho.toggleterm-nvim.keys"),
    },
    -- Undo tree
    {
        "mbbill/undotree",
        cmd = {
            "UndotreeToggle",
            "UndotreeHide",
            "UndotreeShow",
            "UndotreeFocus",
        },
        keys = require("repo.mbbill.undotree.keys"),
    },
    -- Other
    {
        "tpope/vim-repeat",
        event = { "BufReadPost" },
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = { "BufReadPost" },
        config = function()
            require("repo.kylechui.nvim-surround.config")
        end,
    },
    {
        "editorconfig/editorconfig-vim",
        event = { "InsertEnter" },
    },
    {
        "axieax/urlview.nvim",
        cmd = { "UrlView" },
        config = function()
            require("repo.axieax.urlview-nvim.config")
        end,
        keys = require("repo.axieax.urlview-nvim.keys"),
    },
}

-- ---- Plugins Footer ----